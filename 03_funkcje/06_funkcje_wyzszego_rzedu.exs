# Funkcje wyższego rzędu w Elixir

IO.puts("=== Funkcje wyższego rzędu w Elixir ===\n")

# Funkcje wyższego rzędu to funkcje, które przyjmują inne funkcje jako argumenty
# lub zwracają funkcje jako wyniki.

# ------ Podstawowe przykłady ------
IO.puts("--- Podstawowe przykłady ---")

lista = [1, 2, 3, 4, 5]

# Enum.map/2 - przekształca każdy element listy za pomocą funkcji
podwojone = Enum.map(lista, fn x -> x * 2 end)
IO.puts("Lista oryginalna: #{inspect(lista)}")
IO.puts("Lista podwojona: #{inspect(podwojone)}")

# Enum.filter/2 - filtruje listę za pomocą funkcji predykatu
parzyste = Enum.filter(lista, fn x -> rem(x, 2) == 0 end)
IO.puts("Lista liczb parzystych: #{inspect(parzyste)}")

# Enum.reduce/3 - redukuje listę do pojedynczej wartości
suma = Enum.reduce(lista, 0, fn x, acc -> x + acc end)
IO.puts("Suma wszystkich elementów: #{suma}")

# ------ Własne funkcje wyższego rzędu ------
IO.puts("\n--- Własne funkcje wyższego rzędu ---")

defmodule FunkcjeWyzszegoRzedu do
  # Funkcja przyjmująca inną funkcję jako argument
  def zastosuj_dla_kazdego(lista, funkcja) do
    for element <- lista, do: funkcja.(element)
  end

  # Funkcja zwracająca inną funkcję
  def stworz_mnoznik(n) do
    fn x -> x * n end
  end

  # Funkcja przyjmująca dwie funkcje i komponująca je
  def kompozycja(f, g) do
    fn x -> f.(g.(x)) end
  end

  # Funkcja curried (rozdzielone argumenty)
  def dodaj(a) do
    fn b -> a + b end
  end
end

# Zastosowanie własnej funkcji wyższego rzędu
IO.puts("\nZastosowanie własnej funkcji wyższego rzędu:")
kwadraty = FunkcjeWyzszegoRzedu.zastosuj_dla_kazdego(lista, fn x -> x * x end)
IO.puts("Kwadraty: #{inspect(kwadraty)}")

# Funkcja zwracająca funkcję
IO.puts("\nFunkcja zwracająca funkcję:")
pomnoz_przez_10 = FunkcjeWyzszegoRzedu.stworz_mnoznik(10)
IO.puts("5 * 10 = #{pomnoz_przez_10.(5)}")

# Kompozycja funkcji
IO.puts("\nKompozycja funkcji:")
do_kwadratu = fn x -> x * x end
plus_jeden = fn x -> x + 1 end
kwadrat_plus_jeden = FunkcjeWyzszegoRzedu.kompozycja(plus_jeden, do_kwadratu)
IO.puts("(3^2) + 1 = #{kwadrat_plus_jeden.(3)}")

# Funkcja curried
IO.puts("\nFunkcja curried (częściowa aplikacja):")
dodaj_piec = FunkcjeWyzszegoRzedu.dodaj(5)
IO.puts("5 + 3 = #{dodaj_piec.(3)}")

# ------ Funkcje z modułu Enum ------
IO.puts("\n--- Przydatne funkcje z modułu Enum ---")

lista = [5, 2, 8, 1, 6]

# Sortowanie z funkcją porównującą
posortowane_rosnaco = Enum.sort(lista, fn a, b -> a <= b end)
posortowane_malejaco = Enum.sort(lista, fn a, b -> a >= b end)
IO.puts("Lista oryginalna: #{inspect(lista)}")
IO.puts("Posortowana rosnąco: #{inspect(posortowane_rosnaco)}")
IO.puts("Posortowana malejąco: #{inspect(posortowane_malejaco)}")

# Funkcja all?/2 - sprawdza czy wszystkie elementy spełniają warunek
wszystkie_dodatnie = Enum.all?(lista, fn x -> x > 0 end)
wszystkie_parzyste = Enum.all?(lista, fn x -> rem(x, 2) == 0 end)
IO.puts("\nCzy wszystkie elementy są dodatnie?: #{wszystkie_dodatnie}")
IO.puts("Czy wszystkie elementy są parzyste?: #{wszystkie_parzyste}")

# Funkcja any?/2 - sprawdza czy którykolwiek element spełnia warunek
jakis_wiekszy_niz_7 = Enum.any?(lista, fn x -> x > 7 end)
IO.puts("\nCzy jakikolwiek element jest > 7?: #{jakis_wiekszy_niz_7}")

# Funkcja chunk_by/2 - grupuje elementy według wyników funkcji
slowa = ["kot", "pies", "koń", "ryba", "ptak", "słoń"]
pogrupowane = Enum.chunk_by(slowa, fn s -> String.length(s) end)
IO.puts("\nSłowa: #{inspect(slowa)}")
IO.puts("Pogrupowane według długości: #{inspect(pogrupowane)}")

# ------ Przechwytywanie i przekazywanie funkcji ------
IO.puts("\n--- Przechwytywanie i przekazywanie funkcji ---")

# Operator &, skrócona notacja dla funkcji anonimowych
kwadraty = Enum.map(lista, &(&1 * &1))
IO.puts("Kwadraty (notacja &): #{inspect(kwadraty)}")

# Przechwytywanie funkcji istniejących
podwojone = Enum.map(lista, &(2 * &1))
IO.puts("Podwojone (notacja &): #{inspect(podwojone)}")

# Referencja do nazwanej funkcji - inny sposób przekazywania funkcji
defmodule Pomocnik do
  def do_kwadratu(x), do: x * x
  def podwoj(x), do: x * 2
end

kwadraty = Enum.map(lista, &Pomocnik.do_kwadratu/1)
IO.puts("\nKwadraty (referencja do funkcji): #{inspect(kwadraty)}")

# Referencja do funkcji w tym samym module
defmodule Kalkulator do
  def potegi(lista) do
    kwadrat = &do_kwadratu/1
    szescian = &do_szescianu/1

    kwadraty = Enum.map(lista, kwadrat)
    szesciany = Enum.map(lista, szescian)

    {kwadraty, szesciany}
  end

  defp do_kwadratu(x), do: x * x
  defp do_szescianu(x), do: x * x * x
end

{kwadraty, szesciany} = Kalkulator.potegi(lista)
IO.puts("Kwadraty: #{inspect(kwadraty)}")
IO.puts("Sześciany: #{inspect(szesciany)}")

# ------ Zagnieżdżone funkcje wyższego rzędu ------
IO.puts("\n--- Zagnieżdżone funkcje wyższego rzędu ---")

osoby = [
  %{imie: "Jan", wiek: 25, płeć: "M"},
  %{imie: "Anna", wiek: 32, płeć: "K"},
  %{imie: "Piotr", wiek: 17, płeć: "M"},
  %{imie: "Zofia", wiek: 45, płeć: "K"},
  %{imie: "Marek", wiek: 28, płeć: "M"}
]

# Łączenie operacji na kolekcjach
pelnoletnie_kobiety = osoby
  |> Enum.filter(fn osoba -> osoba.płeć == "K" end)
  |> Enum.filter(fn osoba -> osoba.wiek >= 18 end)
  |> Enum.map(fn osoba -> osoba.imie end)

IO.puts("Pełnoletnie kobiety: #{inspect(pelnoletnie_kobiety)}")

# Grupowanie i przetwarzanie danych
grupowanie_po_plci = Enum.group_by(osoby, fn osoba -> osoba.płeć end)
sredni_wiek_wedlug_plci =
  Enum.map(grupowanie_po_plci, fn {plec, grupa} ->
    sredni_wiek = Enum.reduce(grupa, 0, fn osoba, acc -> acc + osoba.wiek end) / length(grupa)
    {plec, Float.round(sredni_wiek, 1)}
  end)
  |> Enum.into(%{})

IO.puts("\nŚredni wiek według płci: #{inspect(sredni_wiek_wedlug_plci)}")

# ------ Praktyczne zastosowania ------
IO.puts("\n--- Praktyczne zastosowania ---")

# Budowanie potoku funkcji przetwarzających dane
defmodule ObslugaDanych do
  def przetworz_dane(dane, operacje) do
    Enum.reduce(operacje, dane, fn operacja, aktualne_dane ->
      operacja.(aktualne_dane)
    end)
  end

  def normalizuj_tekst(tekst) do
    String.downcase(tekst) |> String.trim()
  end

  def usun_znaki_specjalne(tekst) do
    String.replace(tekst, ~r/[^a-ząćęłńóśźż\s]/u, "")
  end

  def podziel_na_slowa(tekst) do
    String.split(tekst, ~r/\s+/)
  end

  def policz_slowa(lista_slow) do
    Enum.frequencies(lista_slow)
  end
end

# Użycie potoku funkcji
tekst = "  To jest PRZYKŁADOWY tekst; zawiera różne ZNAKI i słowa!  "

operacje = [
  &ObslugaDanych.normalizuj_tekst/1,
  &ObslugaDanych.usun_znaki_specjalne/1,
  &ObslugaDanych.podziel_na_slowa/1,
  &ObslugaDanych.policz_slowa/1
]

wynik = ObslugaDanych.przetworz_dane(tekst, operacje)
IO.puts("Oryginalny tekst: #{tekst}")
IO.puts("Wynik przetwarzania (częstość słów): #{inspect(wynik)}")

# ------ Zakończenie ------
IO.puts("\nTo podsumowuje funkcje wyższego rzędu w Elixirze!")
