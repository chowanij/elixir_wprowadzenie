# Komunikacja między procesami w Elixir

IO.puts("=== Komunikacja między procesami w Elixir ===\n")

# ------ Wzorce komunikacji ------
IO.puts("--- Podstawowe wzorce komunikacji ---")

# W Elixir procesy komunikują się poprzez wysyłanie wiadomości
# Jest to model "współdzielenie przez komunikację", a nie "komunikacja przez współdzielenie"

# ------ Jednokierunkowa komunikacja ------
IO.puts("\n--- Jednokierunkowa komunikacja ---")

# Jednokierunkowe wysyłanie wiadomości (fire and forget)
worker_pid = spawn(fn ->
  receive do
    {:praca, zadanie} -> IO.puts("Wykonuję zadanie: #{zadanie}")
  end
end)

IO.puts("Wysyłam zadanie do procesu #{inspect(worker_pid)}")
send(worker_pid, {:praca, "analiza danych"})
:timer.sleep(100)  # Dajmy czas na przetworzenie

# ------ Dwukierunkowa komunikacja (request-response) ------
IO.puts("\n--- Dwukierunkowa komunikacja ---")

# Często potrzebujemy odpowiedzi od procesu - wzorzec request-response
calculator_pid = spawn(fn ->
  receive do
    {:dodaj, a, b, caller_pid} ->
      wynik = a + b
      IO.puts("Wykonuję dodawanie: #{a} + #{b} = #{wynik}")
      send(caller_pid, {:wynik, wynik})
  end
end)

# Wysyłamy żądanie z PID aktualnego procesu
IO.puts("Wysyłam zadanie obliczeniowe")
send(calculator_pid, {:dodaj, 10, 20, self()})

# Czekamy na odpowiedź
receive do
  {:wynik, wartosc} -> IO.puts("Otrzymano wynik: #{wartosc}")
after
  1000 -> IO.puts("Nie otrzymano odpowiedzi w ciągu 1 sekundy")
end

# ------ Wielokrotne przetwarzanie wiadomości ------
IO.puts("\n--- Wielokrotne przetwarzanie wiadomości ---")

defmodule KalkulatorProcessu do
  def start do
    spawn(fn -> petla() end)
  end

  def petla do
    receive do
      {:dodaj, a, b, caller_pid} ->
        wynik = a + b
        send(caller_pid, {:wynik, wynik})
        petla()  # Kontynuujemy pętlę po obsłudze wiadomości

      {:pomnoz, a, b, caller_pid} ->
        wynik = a * b
        send(caller_pid, {:wynik, wynik})
        petla()

      {:zatrzymaj} ->
        IO.puts("Kalkulator zatrzymany")
        # Nie wywołujemy petla(), więc proces zakończy działanie
    end
  end
end

kalkulator = KalkulatorProcessu.start()

# Pierwsza operacja - dodawanie
send(kalkulator, {:dodaj, 10, 20, self()})
receive do
  {:wynik, wartosc} -> IO.puts("Wynik dodawania: #{wartosc}")
after
  1000 -> IO.puts("Brak odpowiedzi")
end

# Druga operacja - mnożenie
send(kalkulator, {:pomnoz, 10, 20, self()})
receive do
  {:wynik, wartosc} -> IO.puts("Wynik mnożenia: #{wartosc}")
after
  1000 -> IO.puts("Brak odpowiedzi")
end

# Zatrzymanie kalkulatora
send(kalkulator, {:zatrzymaj})
:timer.sleep(100)

# ------ Selektywne odbieranie wiadomości ------
IO.puts("\n--- Selektywne odbieranie wiadomości ---")

# Funkcja receive obsługuje wiadomości w kolejności ich dopasowania do wzorców
# Jeśli wiadomość nie pasuje do wzorca, pozostaje w kolejce

defmodule SelektywnyOdbiorca do
  def start do
    spawn(fn ->
      receive do
        {:priorytet} -> IO.puts("Otrzymano wiadomość priorytetową")
      after
        1000 -> IO.puts("Nie otrzymano wiadomości priorytetowej, sprawdzam inne wiadomości")
      end

      receive do
        {:normalna} -> IO.puts("Otrzymano normalną wiadomość")
        {:inna} -> IO.puts("Otrzymano inną wiadomość")
      after
        1000 -> IO.puts("Nie otrzymano żadnej innej wiadomości")
      end
    end)
  end
end

odbiorca = SelektywnyOdbiorca.start()

# Wysłanie wiadomości o niższym priorytecie najpierw
send(odbiorca, {:normalna})
:timer.sleep(100)

# Wysłanie wiadomości priorytetowej
send(odbiorca, {:priorytet})
:timer.sleep(2000)

# ------ Wzorzec klient-serwer ------
IO.puts("\n--- Wzorzec klient-serwer ---")

defmodule Serwer do
  def start do
    spawn(fn -> petla(%{}) end)
  end

  def petla(stan) do
    receive do
      # Obsługa zapytania get - pobranie wartości
      {:get, klucz, klient_pid} ->
        wartość = Map.get(stan, klucz, nil)
        send(klient_pid, {:odpowiedz, wartość})
        petla(stan)

      # Obsługa zapytania set - ustawienie wartości
      {:set, klucz, wartość} ->
        nowy_stan = Map.put(stan, klucz, wartość)
        petla(nowy_stan)

      # Obsługa zapytania list - lista wszystkich kluczy
      {:list, klient_pid} ->
        klucze = Map.keys(stan)
        send(klient_pid, {:odpowiedz, klucze})
        petla(stan)

      # Obsługa zapytania o zatrzymanie serwera
      {:stop} ->
        IO.puts("Serwer zatrzymany")
    end
  end
end

# Funkcje pomocnicze dla klienta
defmodule KlientSerwera do
  def get(serwer_pid, klucz) do
    send(serwer_pid, {:get, klucz, self()})
    receive do
      {:odpowiedz, wartość} -> wartość
    after
      1000 -> {:blad, :timeout}
    end
  end

  def set(serwer_pid, klucz, wartość) do
    send(serwer_pid, {:set, klucz, wartość})
  end

  def list(serwer_pid) do
    send(serwer_pid, {:list, self()})
    receive do
      {:odpowiedz, klucze} -> klucze
    after
      1000 -> {:blad, :timeout}
    end
  end

  def stop(serwer_pid) do
    send(serwer_pid, {:stop})
  end
end

# Uruchamiamy serwer
serwer = Serwer.start()

# Używamy funkcji klienckich do komunikacji z serwerem
KlientSerwera.set(serwer, :imie, "Jan")
KlientSerwera.set(serwer, :wiek, 30)
KlientSerwera.set(serwer, :zawod, "programista")

# Pobieramy wartości
imie = KlientSerwera.get(serwer, :imie)
wiek = KlientSerwera.get(serwer, :wiek)
nieznany = KlientSerwera.get(serwer, :nieznany_klucz)

IO.puts("Pobrane wartości:")
IO.puts("imie: #{inspect(imie)}")
IO.puts("wiek: #{inspect(wiek)}")
IO.puts("nieznany_klucz: #{inspect(nieznany)}")

# Lista wszystkich kluczy
klucze = KlientSerwera.list(serwer)
IO.puts("Lista kluczy: #{inspect(klucze)}")

# Zatrzymanie serwera
KlientSerwera.stop(serwer)
:timer.sleep(100)

# ------ Implementacja prostego licznika odwiedzin ------
IO.puts("\n--- Przykład: licznik odwiedzin ---")

defmodule LicznikOdwiedzin do
  def start do
    spawn(fn -> petla(%{}) end)
  end

  def petla(liczniki) do
    receive do
      # Zarejestruj odwiedziny dla danego URL
      {:odwiedz, url} ->
        nowe_liczniki = Map.update(liczniki, url, 1, &(&1 + 1))
        petla(nowe_liczniki)

      # Pobierz liczbę odwiedzin dla danego URL
      {:pobierz, url, pid} ->
        liczba = Map.get(liczniki, url, 0)
        send(pid, {:licznik, url, liczba})
        petla(liczniki)

      # Pobierz wszystkie statystyki
      {:statystyki, pid} ->
        send(pid, {:statystyki, liczniki})
        petla(liczniki)
    end
  end
end

# Uruchom licznik odwiedzin
licznik = LicznikOdwiedzin.start()

# Symulacja odwiedzin stron
strony = [
  "https://example.com/home",
  "https://example.com/about",
  "https://example.com/contact",
  "https://example.com/home",
  "https://example.com/home",
  "https://example.com/about"
]

# Rejestracja odwiedzin
Enum.each(strony, fn url ->
  send(licznik, {:odwiedz, url})
end)

# Pobranie statystyk dla konkretnej strony
send(licznik, {:pobierz, "https://example.com/home", self()})
receive do
  {:licznik, url, liczba} ->
    IO.puts("Strona #{url} została odwiedzona #{liczba} razy")
end

# Pobranie wszystkich statystyk
send(licznik, {:statystyki, self()})
receive do
  {:statystyki, wszystkie} ->
    IO.puts("Wszystkie statystyki:")
    Enum.each(wszystkie, fn {url, liczba} ->
      IO.puts("  #{url}: #{liczba} odwiedzin")
    end)
end

IO.puts("\nTo podsumowuje podstawowe wzorce komunikacji między procesami w Elixir!")
