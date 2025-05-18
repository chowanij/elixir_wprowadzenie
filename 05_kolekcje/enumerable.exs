# Protokół Enumerable i moduł Enum w Elixir

IO.puts("=== Protokół Enumerable i moduł Enum w Elixir ===\n")

# ------ Wprowadzenie do Enumerable ------
IO.puts("--- Wprowadzenie do Enumerable ---")

IO.puts("Protokół Enumerable określa interfejs dla kolekcji umożliwiający iteracje.")
IO.puts("Typy implementujące Enumerable: listy, mapy, zakresy, MapSet, Stream, itp.")
IO.puts("Własne struktury mogą również implementować ten protokół.")

# ------ Podstawowe operacje modułu Enum ------
IO.puts("\n--- Podstawowe operacje modułu Enum ---")

# Przykładowe kolekcje
lista = [1, 2, 3, 4, 5]
mapa = %{a: 1, b: 2, c: 3}
zakres = 1..10
mapset = MapSet.new([1, 2, 3, 4, 5, 5, 5])

# Enum.map - transformacja każdego elementu
IO.puts("\nEnum.map:")
lista_kwadratow = Enum.map(lista, fn x -> x * x end)
IO.puts("Kwadraty liczb: #{inspect(lista_kwadratow)}")

mapa_wartosci_podwojnych = Enum.map(mapa, fn {k, v} -> {k, v * 2} end)
IO.puts("Mapa z podwojonymi wartościami: #{inspect(mapa_wartosci_podwojnych)}")

# Enum.filter - wybieranie elementów spełniających warunek
IO.puts("\nEnum.filter:")
parzyste = Enum.filter(lista, fn x -> rem(x, 2) == 0 end)
IO.puts("Parzyste liczby: #{inspect(parzyste)}")

# Enum.reduce - redukcja kolekcji do pojedynczej wartości
IO.puts("\nEnum.reduce:")
suma = Enum.reduce(lista, 0, fn x, acc -> x + acc end)
IO.puts("Suma elementów listy: #{suma}")

suma_kwadratow = Enum.reduce(lista, 0, fn x, acc -> x * x + acc end)
IO.puts("Suma kwadratów elementów: #{suma_kwadratow}")

# Enum.count - liczenie elementów
IO.puts("\nEnum.count:")
IO.puts("Liczba elementów listy: #{Enum.count(lista)}")
IO.puts("Liczba elementów mapy: #{Enum.count(mapa)}")
IO.puts("Liczba elementów MapSet: #{Enum.count(mapset)}")
IO.puts("Liczba parzystych w liście: #{Enum.count(lista, fn x -> rem(x, 2) == 0 end)}")

# ------ Sortowanie i grupowanie ------
IO.puts("\n--- Sortowanie i grupowanie ---")

# Enum.sort
IO.puts("\nEnum.sort:")
nieposortowana = [5, 3, 1, 4, 2]
posortowana = Enum.sort(nieposortowana)
IO.puts("Posortowana lista: #{inspect(posortowana)}")

posortowana_malejaco = Enum.sort(nieposortowana, :desc)
IO.puts("Posortowana malejąco: #{inspect(posortowana_malejaco)}")

# Sortowanie z własną funkcją porównującą
ludzie = [
  %{imie: "Jan", wiek: 30},
  %{imie: "Anna", wiek: 28},
  %{imie: "Piotr", wiek: 35}
]

posortowani_wg_wieku = Enum.sort_by(ludzie, fn osoba -> osoba.wiek end)
IO.puts("Posortowani wg wieku: #{inspect(posortowani_wg_wieku)}")

# Enum.group_by - grupowanie elementów
IO.puts("\nEnum.group_by:")
grupy_parzystosci = Enum.group_by(1..10, fn x -> rem(x, 2) == 0 end)
IO.puts("Grupy parzystości: #{inspect(grupy_parzystosci)}")

oceny = [
  %{student: "Jan", przedmiot: "Matematyka", ocena: 5},
  %{student: "Jan", przedmiot: "Fizyka", ocena: 4},
  %{student: "Anna", przedmiot: "Matematyka", ocena: 4},
  %{student: "Anna", przedmiot: "Fizyka", ocena: 5}
]

oceny_wg_studenta = Enum.group_by(oceny, fn wpis -> wpis.student end)
IO.puts("Oceny według studentów: #{inspect(oceny_wg_studenta)}")

# ------ Funkcje wyszukiwania ------
IO.puts("\n--- Funkcje wyszukiwania ---")

# Enum.find - znalezienie pierwszego pasującego elementu
IO.puts("\nEnum.find:")
pierwsza_parzysta = Enum.find(1..10, fn x -> rem(x, 2) == 0 end)
IO.puts("Pierwsza parzysta liczba: #{pierwsza_parzysta}")

nie_znalezione = Enum.find(1..10, "Nie znaleziono", fn x -> x > 20 end)
IO.puts("Liczba > 20: #{nie_znalezione}")

# Enum.any? - sprawdza czy jakikolwiek element spełnia warunek
IO.puts("\nEnum.any?:")
IO.puts("Czy jakakolwiek liczba w liście jest parzysta? #{Enum.any?(lista, fn x -> rem(x, 2) == 0 end)}")
IO.puts("Czy jakakolwiek liczba jest ujemna? #{Enum.any?(lista, fn x -> x < 0 end)}")

# Enum.all? - sprawdza czy wszystkie elementy spełniają warunek
IO.puts("\nEnum.all?:")
IO.puts("Czy wszystkie liczby w liście są dodatnie? #{Enum.all?(lista, fn x -> x > 0 end)}")
IO.puts("Czy wszystkie liczby są parzyste? #{Enum.all?(lista, fn x -> rem(x, 2) == 0 end)}")

# ------ Rozdzielanie i łączenie ------
IO.puts("\n--- Rozdzielanie i łączenie ---")

# Enum.chunk_every - podział na kawałki o równej długości
IO.puts("\nEnum.chunk_every:")
chunks = Enum.chunk_every(1..10, 3)
IO.puts("Kawałki po 3 elementy: #{inspect(chunks)}")

# Enum.zip - łączenie elementów z różnych kolekcji
IO.puts("\nEnum.zip:")
imiona = ["Jan", "Anna", "Piotr"]
nazwiska = ["Kowalski", "Nowak", "Wiśniewski"]
wiek = [30, 28, 35]

osoby = Enum.zip([imiona, nazwiska, wiek])
IO.puts("Połączone dane: #{inspect(osoby)}")

# Enum.zip_with - łączenie z transformacją
osoby_mapy = Enum.zip_with([imiona, nazwiska, wiek], fn [imie, nazwisko, wiek] ->
  %{imie: imie, nazwisko: nazwisko, wiek: wiek}
end)
IO.puts("Osoby jako mapy: #{inspect(osoby_mapy)}")

# ------ Implementacja własnej struktury z protokołem Enumerable ------
IO.puts("\n--- Własna implementacja Enumerable ---")

defmodule FibonacciSequence do
  @moduledoc """
  Implementacja ciągu Fibonacciego jako kolekcji Enumerable.
  """
  defstruct [:limit]

  # Pomocnicza funkcja generująca ciąg Fibonacciego do określonej liczby elementów
  defp generate_fibonacci(n) do
    Stream.unfold({0, 1}, fn {a, b} -> {a, {b, a + b}} end)
    |> Enum.take(n)
  end
end

# Implementacja protokołu Enumerable dla naszej struktury
defimpl Enumerable, for: FibonacciSequence do
  def count(%FibonacciSequence{limit: limit}) do
    {:ok, limit}
  end

  def member?(%FibonacciSequence{}, _value) do
    # Sprawdzenie członkostwa wymagałoby generowania ciągu do momentu znalezienia lub przekroczenia wartości
    # Dla uproszczenia przykładu, zawsze zwracamy {:error, __MODULE__}
    {:error, __MODULE__}
  end

  def slice(%FibonacciSequence{limit: limit}) do
    # Informujemy, że nie implementujemy zoptymalizowanego slice
    {:error, __MODULE__}
  end

  def reduce(%FibonacciSequence{limit: limit}, acc, fun) do
    # Generujemy ciąg Fibonacciego i wywołujemy reduce na nim
    # To jest kluczowa część implementacji
    Stream.unfold({0, 1}, fn {a, b} -> {a, {b, a + b}} end)
    |> Stream.take(limit)
    |> Enumerable.List.reduce(acc, fun)
  end
end

# Korzystanie z własnej implementacji Enumerable
fib = %FibonacciSequence{limit: 10}
IO.puts("\nPierwszych 10 liczb Fibonacciego: #{inspect(Enum.to_list(fib))}")
IO.puts("Suma pierwszych 10 liczb Fibonacciego: #{Enum.sum(fib)}")

# ------ Moduł Stream - leniwe wersje funkcji Enum ------
IO.puts("\n--- Moduł Stream - leniwe ewaluacje ---")

# Tworzenie nieskończonego strumienia
nieskonczone = Stream.iterate(1, &(&1 + 1))

IO.puts("\nPierwsze 5 liczb naturalnych: #{inspect(Enum.take(nieskonczone, 5))}")

# Łańcuchowanie operacji bez tworzenia kolekcji pośrednich
wynik = 1..1_000_000
  |> Stream.filter(fn x -> rem(x, 2) == 0 end)  # Filtrowanie parzystych
  |> Stream.map(fn x -> x * x end)              # Kwadrat każdego elementu
  |> Stream.take(5)                             # Tylko pierwsze 5 elementów
  |> Enum.to_list()                             # Materializacja strumienia

IO.puts("Pierwsze 5 kwadratów liczb parzystych: #{inspect(wynik)}")

# Tworzenie własnego strumienia
primes = Stream.unfold(2, fn n ->
  next_prime = Stream.iterate(n + 1, &(&1 + 1))
    |> Enum.find(fn i ->
      Enum.all?(2..trunc(:math.sqrt(i)), fn j -> rem(i, j) != 0 end)
    end)
  {n, next_prime}
end)

IO.puts("Pierwsze 10 liczb pierwszych: #{inspect(Enum.take(primes, 10))}")

IO.puts("\nTo podsumowuje podstawowe operacje na Enum i Enumerable w Elixir!")
