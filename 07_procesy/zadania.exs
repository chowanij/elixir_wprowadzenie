# Zadania (Tasks) w Elixir

IO.puts("=== Zadania (Tasks) w Elixir ===\n")

# Moduł Task zapewnia wygodny sposób wykonywania jednorazowych zadań asynchronicznie
# oraz zbierania ich wyników.

# ------ Podstawowe użycie Task.async/1 i Task.await/1 ------
IO.puts("--- Podstawowe użycie Task.async/1 i Task.await/1 ---")

# Task.async uruchamia funkcję w osobnym procesie i zwraca referencję do zadania
task = Task.async(fn ->
  # Symulacja długiego obliczenia
  :timer.sleep(1000)
  "Wynik obliczenia"
end)

IO.puts("Zadanie uruchomione, PID: #{inspect(task.pid)}")
IO.puts("Możemy wykonywać inne operacje podczas gdy zadanie działa...")

# Task.await czeka na zakończenie zadania i zwraca jego wynik
wynik = Task.await(task)
IO.puts("Otrzymany wynik: #{wynik}")

# ------ Task.async z modułem, funkcją i argumentami ------
IO.puts("\n--- Task.async z MFA ---")

defmodule Kalkulator do
  def dodaj(a, b) do
    # Symulacja złożonego obliczenia
    :timer.sleep(500)
    a + b
  end

  def pomnoz(a, b) do
    # Symulacja złożonego obliczenia
    :timer.sleep(700)
    a * b
  end
end

# Uruchomienie zadania z użyciem MFA (Module, Function, Arguments)
task = Task.async(Kalkulator, :dodaj, [10, 20])
IO.puts("Zadanie dodawania uruchomione")

# Możemy wykonywać inne operacje w międzyczasie
IO.puts("Wykonujemy inne operacje...")

# Oczekiwanie na wynik
wynik = Task.await(task)
IO.puts("Wynik dodawania: #{wynik}")

# ------ Uruchamianie wielu zadań równolegle ------
IO.puts("\n--- Uruchamianie wielu zadań równolegle ---")

# Lista danych wejściowych
dane = [
  {1, 2},
  {3, 4},
  {5, 6},
  {7, 8}
]

start_time = System.monotonic_time(:millisecond)

# Uruchamiamy wiele zadań równolegle
zadania = Enum.map(dane, fn {a, b} ->
  Task.async(fn -> Kalkulator.pomnoz(a, b) end)
end)

# Zbieramy wyniki wszystkich zadań
wyniki = Enum.map(zadania, &Task.await/1)

end_time = System.monotonic_time(:millisecond)
czas_wykonania = end_time - start_time

IO.puts("Wyniki mnożenia: #{inspect(wyniki)}")
IO.puts("Czas wykonania: #{czas_wykonania} ms")

# Porównajmy z sekwencyjnym wykonaniem
start_time = System.monotonic_time(:millisecond)

wyniki_sekwencyjne = Enum.map(dane, fn {a, b} ->
  Kalkulator.pomnoz(a, b)
end)

end_time = System.monotonic_time(:millisecond)
czas_sekwencyjny = end_time - start_time

IO.puts("Wyniki sekwencyjne: #{inspect(wyniki_sekwencyjne)}")
IO.puts("Czas sekwencyjny: #{czas_sekwencyjny} ms")
IO.puts("Przyspieszenie: #{czas_sekwencyjny / czas_wykonania}x")

# ------ Task.yield i timeout ------
IO.puts("\n--- Task.yield i timeout ---")

# Task.yield pozwala na oczekiwanie z timeoutem
task = Task.async(fn ->
  # Bardzo długie obliczenie
  :timer.sleep(3000)
  "Wynik długiego obliczenia"
end)

# Próbujemy odebrać wynik z krótkim timeoutem
case Task.yield(task, 1000) do
  {:ok, wynik} ->
    IO.puts("Otrzymano wynik: #{wynik}")
  nil ->
    IO.puts("Zadanie nadal działa po timeoucie")

    # Możemy kontynuować oczekiwanie
    case Task.yield(task, 3000) do
      {:ok, wynik} ->
        IO.puts("Otrzymano wynik po dodatkowym oczekiwaniu: #{wynik}")
      nil ->
        # Lub anulować zadanie
        IO.puts("Anulowanie zadania")
        Task.shutdown(task)
    end
end

# ------ Task.async_stream ------
IO.puts("\n--- Task.async_stream ---")

# Task.async_stream pozwala na przetwarzanie kolekcji równolegle z kontrolą współbieżności
dane = 1..10

IO.puts("Przetwarzanie danych z Task.async_stream (max_concurrency: 4):")

wyniki = Task.async_stream(dane, fn x ->
  # Symulacja pracy
  :timer.sleep(300)
  x * x
end, max_concurrency: 4, timeout: 5000)
|> Enum.to_list()

IO.puts("Wyniki: #{inspect(wyniki)}")

# ------ Task.Supervisor ------
IO.puts("\n--- Task.Supervisor ---")

# Task.Supervisor pozwala na nadzorowanie zadań
{:ok, supervisor} = Task.Supervisor.start_link(name: MojTaskSupervisor)

# Uruchomienie nadzorowanego zadania
task = Task.Supervisor.async(MojTaskSupervisor, fn ->
  :timer.sleep(500)
  "Wynik nadzorowanego zadania"
end)

wynik = Task.await(task)
IO.puts("Wynik nadzorowanego zadania: #{wynik}")

# Uruchomienie zadania, które może się nie powieść
task = Task.Supervisor.async(MojTaskSupervisor, fn ->
  # Symulacja błędu
  :timer.sleep(300)
  if :rand.uniform() > 0.5 do
    raise "Symulowany błąd w zadaniu"
  else
    "Zadanie zakończone sukcesem"
  end
end)

try do
  wynik = Task.await(task)
  IO.puts("Zadanie zakończone: #{wynik}")
catch
  :exit, reason ->
    IO.puts("Zadanie zakończyło się błędem: #{inspect(reason)}")
end

# ------ Task.Supervisor.async_nolink ------
IO.puts("\n--- Task.Supervisor.async_nolink ---")

# async_nolink tworzy zadanie, które nie jest połączone z procesem wywołującym
task = Task.Supervisor.async_nolink(MojTaskSupervisor, fn ->
  # Symulacja błędu
  :timer.sleep(300)
  raise "Błąd w zadaniu bez linku"
end)

try do
  Task.await(task)
catch
  :exit, reason ->
    IO.puts("Złapano błąd z async_nolink: #{inspect(reason)}")
end

IO.puts("Proces główny nadal działa")

# ------ Praktyczny przykład: pobieranie danych z wielu źródeł ------
IO.puts("\n--- Praktyczny przykład: pobieranie danych z wielu źródeł ---")

defmodule ZrodloDanych do
  def pobierz_dane(id) do
    # Symulacja pobierania danych z zewnętrznego źródła
    :timer.sleep(:rand.uniform(1000))
    "Dane z źródła #{id}: #{:rand.uniform(100)}"
  end
end

defmodule Agregator do
  def pobierz_dane_rownolegle(zrodla) do
    # Uruchamiamy zadania dla każdego źródła
    zadania = Enum.map(zrodla, fn zrodlo ->
      Task.async(fn -> ZrodloDanych.pobierz_dane(zrodlo) end)
    end)

    # Zbieramy wyniki z timeoutem
    Enum.map(zadania, fn task ->
      case Task.yield(task, 1500) || Task.shutdown(task) do
        {:ok, wynik} -> {:ok, wynik}
        nil -> {:blad, :timeout}
      end
    end)
  end
end

# Lista źródeł danych
zrodla = [:baza_danych, :api_zewnetrzne, :cache, :system_plikow]

IO.puts("Pobieranie danych z #{length(zrodla)} źródeł równolegle:")
start_time = System.monotonic_time(:millisecond)

wyniki = Agregator.pobierz_dane_rownolegle(zrodla)

end_time = System.monotonic_time(:millisecond)
IO.puts("Czas pobierania: #{end_time - start_time} ms")

# Wyświetlenie wyników
Enum.zip(zrodla, wyniki)
|> Enum.each(fn {zrodlo, wynik} ->
  case wynik do
    {:ok, dane} -> IO.puts("#{zrodlo}: #{dane}")
    {:blad, powod} -> IO.puts("#{zrodlo}: BŁĄD - #{powod}")
  end
end)

IO.puts("\nTo podsumowuje podstawy modułu Task w Elixir!")
