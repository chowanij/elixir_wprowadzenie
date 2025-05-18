# GenServer w Elixir

IO.puts("=== GenServer w Elixir ===\n")

# GenServer to zachowanie (behaviour) w Elixir do budowy procesów serwerowych
# Jest to najczęściej używany sposób zarządzania stanem w aplikacjach Elixir

# ------ Prosty GenServer ------
IO.puts("--- Prosty GenServer ---")

defmodule ProstyLicznik do
  use GenServer

  # API klienta

  def start_link(poczatkowa_wartosc \\ 0) do
    GenServer.start_link(__MODULE__, poczatkowa_wartosc)
  end

  def wartosc(pid) do
    GenServer.call(pid, :wartosc)
  end

  def zwieksz(pid) do
    GenServer.cast(pid, :zwieksz)
  end

  def zwieksz_o(pid, wartosc) do
    GenServer.cast(pid, {:zwieksz_o, wartosc})
  end

  def zatrzymaj(pid) do
    GenServer.stop(pid)
  end

  # Callbacks serwera

  @impl true
  def init(poczatkowa_wartosc) do
    IO.puts("Inicjalizacja licznika z wartością #{poczatkowa_wartosc}")
    {:ok, poczatkowa_wartosc}
  end

  @impl true
  def handle_call(:wartosc, _from, stan) do
    {:reply, stan, stan}
  end

  @impl true
  def handle_cast(:zwieksz, stan) do
    nowy_stan = stan + 1
    IO.puts("Zwiększono licznik do #{nowy_stan}")
    {:noreply, nowy_stan}
  end

  @impl true
  def handle_cast({:zwieksz_o, wartosc}, stan) do
    nowy_stan = stan + wartosc
    IO.puts("Zwiększono licznik o #{wartosc} do #{nowy_stan}")
    {:noreply, nowy_stan}
  end

  @impl true
  def terminate(powod, stan) do
    IO.puts("Zatrzymano licznik (powód: #{inspect(powod)}) z wartością #{stan}")
    :ok
  end
end

# Użycie modułu ProstyLicznik
{:ok, licznik} = ProstyLicznik.start_link(5)

wartosc = ProstyLicznik.wartosc(licznik)
IO.puts("Wartość licznika: #{wartosc}")

ProstyLicznik.zwieksz(licznik)
:timer.sleep(100)

ProstyLicznik.zwieksz_o(licznik, 10)
:timer.sleep(100)

wartosc = ProstyLicznik.wartosc(licznik)
IO.puts("Wartość licznika po zwiększeniu: #{wartosc}")

ProstyLicznik.zatrzymaj(licznik)
:timer.sleep(100)

# ------ GenServer z nazwą ------
IO.puts("\n--- GenServer z nazwą ---")

defmodule NazwanyLicznik do
  use GenServer

  # API klienta

  def start_link(opts \\ []) do
    nazwa = Keyword.get(opts, :nazwa, __MODULE__)
    poczatkowa_wartosc = Keyword.get(opts, :poczatkowa_wartosc, 0)
    GenServer.start_link(__MODULE__, poczatkowa_wartosc, name: nazwa)
  end

  def wartosc(nazwa \\ __MODULE__) do
    GenServer.call(nazwa, :wartosc)
  end

  def zwieksz(nazwa \\ __MODULE__) do
    GenServer.cast(nazwa, :zwieksz)
  end

  def resetuj(nazwa \\ __MODULE__) do
    GenServer.cast(nazwa, :resetuj)
  end

  # Callbacks serwera

  @impl true
  def init(poczatkowa_wartosc) do
    {:ok, poczatkowa_wartosc}
  end

  @impl true
  def handle_call(:wartosc, _from, stan) do
    {:reply, stan, stan}
  end

  @impl true
  def handle_cast(:zwieksz, stan) do
    {:noreply, stan + 1}
  end

  @impl true
  def handle_cast(:resetuj, _stan) do
    {:noreply, 0}
  end
end

# Użycie nazwanego GenServera
{:ok, _pid} = NazwanyLicznik.start_link(nazwa: :moj_licznik, poczatkowa_wartosc: 10)

wartosc = NazwanyLicznik.wartosc(:moj_licznik)
IO.puts("Wartość nazwanego licznika: #{wartosc}")

NazwanyLicznik.zwieksz(:moj_licznik)
:timer.sleep(100)

wartosc = NazwanyLicznik.wartosc(:moj_licznik)
IO.puts("Wartość nazwanego licznika po zwiększeniu: #{wartosc}")

NazwanyLicznik.resetuj(:moj_licznik)
:timer.sleep(100)

wartosc = NazwanyLicznik.wartosc(:moj_licznik)
IO.puts("Wartość nazwanego licznika po zresetowaniu: #{wartosc}")

GenServer.stop(:moj_licznik)

# ------ Zaawansowany GenServer z timeoutami ------
IO.puts("\n--- Zaawansowany GenServer z timeoutami ---")

defmodule AutowylaczalnySerwer do
  use GenServer

  # API klienta

  def start_link(opts \\ []) do
    timeout = Keyword.get(opts, :timeout, 5000)
    GenServer.start_link(__MODULE__, timeout)
  end

  def ping(pid) do
    GenServer.call(pid, :ping)
  end

  def reset_timeout(pid) do
    GenServer.cast(pid, :reset_timeout)
  end

  # Callbacks serwera

  @impl true
  def init(timeout) do
    stan = %{
      timeout: timeout,
      ostatnia_aktywnosc: System.monotonic_time(:millisecond)
    }
    harmonogram_sprawdzania()
    {:ok, stan}
  end

  @impl true
  def handle_call(:ping, _from, stan) do
    nowy_stan = %{stan | ostatnia_aktywnosc: System.monotonic_time(:millisecond)}
    {:reply, :pong, nowy_stan}
  end

  @impl true
  def handle_cast(:reset_timeout, stan) do
    nowy_stan = %{stan | ostatnia_aktywnosc: System.monotonic_time(:millisecond)}
    {:noreply, nowy_stan}
  end

  @impl true
  def handle_info(:sprawdz_timeout, stan) do
    teraz = System.monotonic_time(:millisecond)
    czas_bezczynnosci = teraz - stan.ostatnia_aktywnosc

    if czas_bezczynnosci > stan.timeout do
      IO.puts("Serwer bezczynny przez #{czas_bezczynnosci} ms, zatrzymywanie...")
      {:stop, :normal, stan}
    else
      pozostalo = stan.timeout - czas_bezczynnosci
      IO.puts("Serwer aktywny, pozostało #{pozostalo} ms do timeout")
      harmonogram_sprawdzania()
      {:noreply, stan}
    end
  end

  defp harmonogram_sprawdzania do
    Process.send_after(self(), :sprawdz_timeout, 1000)
  end

  @impl true
  def terminate(powod, _stan) do
    IO.puts("AutowylaczalnySerwer zatrzymany z powodem: #{inspect(powod)}")
    :ok
  end
end

# Użycie serwera z auto-wyłączaniem
{:ok, serwer} = AutowylaczalnySerwer.start_link(timeout: 3000)

# Pingujemy serwer, aby resetować timeout
for _ <- 1..3 do
  odpowiedz = AutowylaczalnySerwer.ping(serwer)
  IO.puts("Odpowiedź serwera: #{inspect(odpowiedz)}")
  :timer.sleep(1500)
end

# Poczekajmy, aby serwer się sam wyłączył
IO.puts("Oczekiwanie na timeout serwera...")
:timer.sleep(3500)

# Sprawdźmy czy serwer nadal działa
if Process.alive?(serwer) do
  IO.puts("Serwer nadal działa")
else
  IO.puts("Serwer zakończył działanie, jak oczekiwano")
end

# ------ GenServer z obsługą błędów ------
IO.puts("\n--- GenServer z obsługą błędów ---")

defmodule OdpornyNaBledySerwer do
  use GenServer

  # API klienta

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def wykonaj_bezpieczne(pid) do
    GenServer.call(pid, :bezpieczne_dzialanie)
  end

  def wywolaj_blad(pid) do
    GenServer.call(pid, :wywolaj_blad)
  end

  def wywolaj_wyjscie(pid) do
    GenServer.cast(pid, :wywolaj_wyjscie)
  end

  # Callbacks serwera

  @impl true
  def init([]) do
    {:ok, %{licznik: 0}}
  end

  @impl true
  def handle_call(:bezpieczne_dzialanie, _from, stan) do
    nowy_stan = %{stan | licznik: stan.licznik + 1}
    {:reply, {:ok, nowy_stan.licznik}, nowy_stan}
  end

  @impl true
  def handle_call(:wywolaj_blad, _from, _stan) do
    # To celowo spowoduje błąd
    1 / 0
  end

  @impl true
  def handle_cast(:wywolaj_wyjscie, _stan) do
    exit(:celowe_wyjscie)
  end

  @impl true
  def terminate(powod, stan) do
    IO.puts("OdpornyNaBledySerwer zatrzymany: #{inspect(powod)}")
    IO.puts("Stan w momencie zatrzymania: #{inspect(stan)}")
    :ok
  end
end

# Użycie obsługi błędów w GenServer
{:ok, serwer} = OdpornyNaBledySerwer.start_link()

# Bezpieczne działanie
{:ok, licznik} = OdpornyNaBledySerwer.wykonaj_bezpieczne(serwer)
IO.puts("Wynik bezpiecznego działania: #{licznik}")

# Obsługa błędu z try/catch
try do
  OdpornyNaBledySerwer.wywolaj_blad(serwer)
catch
  :exit, reason ->
    IO.puts("Przechwycono błąd: #{inspect(reason)}")
end

# Sprawdzenie czy serwer nadal działa po błędzie
if Process.alive?(serwer) do
  IO.puts("Serwer nadal działa pomimo błędu w poprzednim wywołaniu")

  # Celowe wywołanie exit
  OdpornyNaBledySerwer.wywolaj_wyjscie(serwer)
  :timer.sleep(100)

  if Process.alive?(serwer) do
    IO.puts("Serwer nadal działa")
  else
    IO.puts("Serwer zakończył działanie po wywołaniu exit")
  end
else
  IO.puts("Serwer nie działa")
end

# ------ Praktyczny przykład - Magazyn sklepu jako GenServer ------
IO.puts("\n--- Praktyczny przykład - Magazyn sklepu ---")

defmodule MagazynSklepu do
  use GenServer

  # API klienta

  def start_link(opts \\ []) do
    nazwa = Keyword.get(opts, :nazwa, __MODULE__)
    GenServer.start_link(__MODULE__, opts, name: nazwa)
  end

  def dodaj_produkt(nazwa \\ __MODULE__, produkt, ilosc) do
    GenServer.cast(nazwa, {:dodaj_produkt, produkt, ilosc})
  end

  def pobierz_produkt(nazwa \\ __MODULE__, produkt, ilosc) do
    GenServer.call(nazwa, {:pobierz_produkt, produkt, ilosc})
  end

  def stan_magazynowy(nazwa \\ __MODULE__, produkt \\ nil) do
    GenServer.call(nazwa, {:stan_magazynowy, produkt})
  end

  # Callbacks serwera

  @impl true
  def init(opts) do
    poczatkowy_stan = Keyword.get(opts, :poczatkowy_stan, %{})
    {:ok, poczatkowy_stan}
  end

  @impl true
  def handle_cast({:dodaj_produkt, produkt, ilosc}, stan) when ilosc > 0 do
    nowy_stan = Map.update(stan, produkt, ilosc, &(&1 + ilosc))
    IO.puts("Dodano #{ilosc} sztuk produktu #{produkt} do magazynu")
    {:noreply, nowy_stan}
  end

  @impl true
  def handle_cast({:dodaj_produkt, produkt, _}, stan) do
    IO.puts("Nie można dodać ujemnej ilości produktu #{produkt}")
    {:noreply, stan}
  end

  @impl true
  def handle_call({:pobierz_produkt, produkt, ilosc}, _from, stan) do
    obecna_ilosc = Map.get(stan, produkt, 0)

    if obecna_ilosc >= ilosc do
      nowy_stan =
        if obecna_ilosc == ilosc do
          Map.delete(stan, produkt)
        else
          Map.put(stan, produkt, obecna_ilosc - ilosc)
        end

      IO.puts("Pobrano #{ilosc} sztuk produktu #{produkt} z magazynu")
      {:reply, {:ok, ilosc}, nowy_stan}
    else
      IO.puts("Nie można pobrać #{ilosc} sztuk produktu #{produkt}, dostępne: #{obecna_ilosc}")
      {:reply, {:blad, :niewystarczajaca_ilosc, obecna_ilosc}, stan}
    end
  end

  @impl true
  def handle_call({:stan_magazynowy, nil}, _from, stan) do
    {:reply, stan, stan}
  end

  @impl true
  def handle_call({:stan_magazynowy, produkt}, _from, stan) do
    ilosc = Map.get(stan, produkt, 0)
    {:reply, ilosc, stan}
  end
end

# Uruchomienie magazynu z początkowym stanem
poczatkowy_stan = %{
  "telefon" => 10,
  "laptop" => 5,
  "tablet" => 8
}

{:ok, _magazyn} = MagazynSklepu.start_link(nazwa: :sklep, poczatkowy_stan: poczatkowy_stan)

# Pobieranie pełnego stanu magazynowego
stan = MagazynSklepu.stan_magazynowy(:sklep)
IO.puts("Stan magazynowy:")
Enum.each(stan, fn {produkt, ilosc} -> IO.puts("  #{produkt}: #{ilosc} szt.") end)

# Pobieranie stanu konkretnego produktu
laptopy = MagazynSklepu.stan_magazynowy(:sklep, "laptop")
IO.puts("Liczba laptopów: #{laptopy} szt.")

# Pobieranie produktu
case MagazynSklepu.pobierz_produkt(:sklep, "telefon", 3) do
  {:ok, ilosc} -> IO.puts("Pomyślnie pobrano #{ilosc} szt. telefonu")
  {:blad, :niewystarczajaca_ilosc, dostepne} -> IO.puts("Błąd: dostępne tylko #{dostepne} szt.")
end

# Pobieranie zbyt dużej ilości
case MagazynSklepu.pobierz_produkt(:sklep, "laptop", 10) do
  {:ok, ilosc} -> IO.puts("Pomyślnie pobrano #{ilosc} szt. laptopa")
  {:blad, :niewystarczajaca_ilosc, dostepne} -> IO.puts("Błąd: dostępne tylko #{dostepne} szt.")
end

# Dodawanie produktu
MagazynSklepu.dodaj_produkt(:sklep, "smartwatch", 15)
:timer.sleep(100)

# Sprawdzenie stanu po operacjach
stan = MagazynSklepu.stan_magazynowy(:sklep)
IO.puts("\nStan magazynowy po operacjach:")
Enum.each(stan, fn {produkt, ilosc} -> IO.puts("  #{produkt}: #{ilosc} szt.") end)

IO.puts("\nTo podsumowuje podstawy GenServer w Elixir!")
