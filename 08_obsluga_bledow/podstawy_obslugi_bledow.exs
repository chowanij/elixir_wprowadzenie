# Podstawy obsługi błędów w Elixir

IO.puts("=== Podstawy obsługi błędów w Elixir ===\n")

# ------ Zgłaszanie wyjątków ------
IO.puts("--- Zgłaszanie wyjątków ---")

# Funkcja raise/1 zgłasza wyjątek z podanym komunikatem
try do
  IO.puts("Próba zgłoszenia wyjątku...")
  raise "To jest wyjątek"
rescue
  e in RuntimeError -> IO.puts("Złapano wyjątek: #{e.message}")
end

# Funkcja raise/2 zgłasza wyjątek określonego typu
try do
  IO.puts("\nPróba zgłoszenia wyjątku określonego typu...")
  raise ArgumentError, message: "Nieprawidłowy argument"
rescue
  e in ArgumentError -> IO.puts("Złapano ArgumentError: #{e.message}")
end

# ------ Definiowanie własnych wyjątków ------
IO.puts("\n--- Definiowanie własnych wyjątków ---")

defmodule MojeBledy do
  # Definiowanie własnego wyjątku
  defexception message: "Wystąpił błąd w aplikacji"
end

defmodule BladBazyDanych do
  defexception [:message, :kod_bledu]

  # Możemy nadpisać metodę message/1 aby dostosować komunikat
  @impl true
  def message(%{message: message, kod_bledu: kod}) do
    "Błąd bazy danych (#{kod}): #{message}"
  end
end

# Użycie własnego wyjątku
try do
  IO.puts("Zgłaszanie własnego wyjątku...")
  raise MojeBledy
rescue
  e in MojeBledy -> IO.puts("Złapano własny wyjątek: #{e.message}")
end

# Użycie wyjątku z dodatkowymi polami
try do
  IO.puts("\nZgłaszanie wyjątku bazy danych...")
  raise BladBazyDanych, message: "Nie można połączyć", kod_bledu: "DB-001"
rescue
  e in BladBazyDanych -> IO.puts("Złapano wyjątek bazy danych: #{Exception.message(e)}")
end

# ------ Obsługa wyjątków z try/rescue ------
IO.puts("\n--- Obsługa wyjątków z try/rescue ---")

defmodule ObslugaBledow do
  def podziel(a, b) do
    try do
      a / b
    rescue
      ArithmeticError -> "Nie można dzielić przez zero"
    end
  end

  def konwertuj_do_liczby(tekst) do
    try do
      String.to_integer(tekst)
    rescue
      ArgumentError -> {:error, "Nie można konwertować '#{tekst}' do liczby"}
    else
      liczba -> {:ok, liczba}  # wykonuje się gdy nie wystąpił wyjątek
    end
  end

  def otworz_plik(sciezka) do
    try do
      File.open!(sciezka)
    rescue
      e in File.Error -> {:error, "Nie można otworzyć pliku: #{e.message}"}
    after
      # Kod w bloku after wykonuje się zawsze, niezależnie czy wystąpił wyjątek
      IO.puts("Próba otwarcia pliku zakończona")
    end
  end
end

# Przykłady użycia
IO.puts("Wynik dzielenia 10/2: #{ObslugaBledow.podziel(10, 2)}")
IO.puts("Wynik dzielenia 10/0: #{ObslugaBledow.podziel(10, 0)}")

IO.puts("\nKonwersja \"123\" do liczby: #{inspect(ObslugaBledow.konwertuj_do_liczby("123"))}")
IO.puts("Konwersja \"abc\" do liczby: #{inspect(ObslugaBledow.konwertuj_do_liczby("abc"))}")

IO.puts("\nPróba otwarcia nieistniejącego pliku:")
wynik = ObslugaBledow.otworz_plik("nieistniejacy_plik.txt")
IO.puts("Wynik: #{inspect(wynik)}")

# ------ Łapanie wszystkich wyjątków ------
IO.puts("\n--- Łapanie wszystkich wyjątków ---")

defmodule BezpieczneWykonanie do
  def wykonaj(fun) do
    try do
      {:ok, fun.()}
    rescue
      e -> {:error, "Wystąpił błąd: #{Exception.message(e)}"}
    end
  end
end

# Przykłady użycia
IO.puts("Bezpieczne wykonanie poprawnej funkcji:")
wynik = BezpieczneWykonanie.wykonaj(fn -> 10 * 2 end)
IO.puts("Wynik: #{inspect(wynik)}")

IO.puts("\nBezpieczne wykonanie funkcji z błędem:")
wynik = BezpieczneWykonanie.wykonaj(fn -> 10 / 0 end)
IO.puts("Wynik: #{inspect(wynik)}")

# ------ Throw i catch ------
IO.puts("\n--- Throw i catch ---")

# throw/catch używane są do wczesnego wyjścia z głęboko zagnieżdżonych wywołań
defmodule WczesneWyjscie do
  def znajdz_element(lista, szukana_wartosc) do
    try do
      for element <- lista do
        if element == szukana_wartosc do
          throw({:znaleziono, element})
        end
      end
      nil  # Nie znaleziono
    catch
      {:znaleziono, wartosc} -> wartosc
    end
  end
end

lista = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
IO.puts("Szukanie elementu 5 w liście: #{WczesneWyjscie.znajdz_element(lista, 5)}")
IO.puts("Szukanie elementu 15 w liście: #{inspect(WczesneWyjscie.znajdz_element(lista, 15))}")

# ------ Exit i catch ------
IO.puts("\n--- Exit i catch ---")

# exit/1 kończy bieżący proces, ale można go złapać w bloku catch
try do
  IO.puts("Próba wywołania exit...")
  exit("Koniec procesu")
  IO.puts("Ten kod nie zostanie wykonany")
catch
  :exit, reason ->
    IO.puts("Złapano exit z powodem: #{inspect(reason)}")
end

# ------ Obsługa błędów w procesach ------
IO.puts("\n--- Obsługa błędów w procesach ---")

# Domyślnie błędy w procesach nie są propagowane do procesu wywołującego
pid = spawn(fn ->
  IO.puts("Proces potomny uruchomiony")
  raise "Błąd w procesie potomnym"
end)

# Dajmy czas na wykonanie procesu
:timer.sleep(100)
IO.puts("Proces główny nadal działa")

# Procesy mogą być połączone, wtedy błędy są propagowane
IO.puts("\nTestowanie połączonych procesów...")
try do
  spawn_link(fn ->
    IO.puts("Połączony proces uruchomiony")
    raise "Błąd w połączonym procesie"
  end)

  # Ten kod nie zostanie wykonany, jeśli proces potomny zgłosi błąd
  :timer.sleep(1000)
  IO.puts("Ten kod nie zostanie wykonany")
catch
  :exit, reason ->
    IO.puts("Złapano błąd z połączonego procesu: #{inspect(reason)}")
end

# ------ Obsługa błędów w praktyce ------
IO.puts("\n--- Obsługa błędów w praktyce ---")

defmodule ObslugaBledowPraktyka do
  # Funkcja, która może zgłaszać wyjątki
  def niebezpieczna_operacja(arg) when is_binary(arg) do
    String.to_integer(arg)
  end

  # Wrapper, który obsługuje błędy
  def bezpieczna_operacja(arg) do
    try do
      {:ok, niebezpieczna_operacja(arg)}
    rescue
      ArgumentError -> {:error, :nieprawidlowy_format}
      e in _ -> {:error, Exception.message(e)}
    end
  end

  # Funkcja używająca wartości specjalnych zamiast wyjątków
  def konwertuj_do_liczby_bezpiecznie(arg) when is_binary(arg) do
    case Integer.parse(arg) do
      {liczba, ""} -> {:ok, liczba}
      {_, _} -> {:error, :niepelna_konwersja}
      :error -> {:error, :nieprawidlowy_format}
    end
  end
end

IO.puts("Bezpieczna operacja z \"123\": #{inspect(ObslugaBledowPraktyka.bezpieczna_operacja("123"))}")
IO.puts("Bezpieczna operacja z \"abc\": #{inspect(ObslugaBledowPraktyka.bezpieczna_operacja("abc"))}")

IO.puts("\nKonwersja bezpieczna \"123\": #{inspect(ObslugaBledowPraktyka.konwertuj_do_liczby_bezpiecznie("123"))}")
IO.puts("Konwersja bezpieczna \"123abc\": #{inspect(ObslugaBledowPraktyka.konwertuj_do_liczby_bezpiecznie("123abc"))}")
IO.puts("Konwersja bezpieczna \"abc\": #{inspect(ObslugaBledowPraktyka.konwertuj_do_liczby_bezpiecznie("abc"))}")

IO.puts("\nTo podsumowuje podstawy obsługi błędów w Elixir!")
