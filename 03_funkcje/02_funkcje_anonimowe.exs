# Funkcje anonimowe w Elixir

IO.puts("=== Funkcje anonimowe w Elixir ===\n")

# Funkcje anonimowe (lambdy) to funkcje bez nazwy, które można przypisać do zmiennych,
# przekazywać jako argumenty do innych funkcji lub zwracać z funkcji.

# ------ Podstawowa składnia ------
IO.puts("--- Podstawowa składnia ---")

# Definicja funkcji anonimowej
dodaj = fn a, b -> a + b end

# Wywołanie funkcji anonimowej
IO.puts("2 + 3 = #{dodaj.(2, 3)}")

# Składnia z nawiasami
pomnoz = fn(a, b) -> a * b end
IO.puts("4 * 5 = #{pomnoz.(4, 5)}")

# Bez argumentów
powiedz_czesc = fn -> "Cześć!" end
IO.puts(powiedz_czesc.())

# ------ Przechwytywanie zmiennych ------
IO.puts("\n--- Przechwytywanie zmiennych ---")

x = 10
dodaj_x = fn y -> x + y end
IO.puts("10 + 5 = #{dodaj_x.(5)}")

# Funkcje anonimowe działają jako domknięcia (closures) - przechowują wartości
# zmiennych z kontekstu, w którym zostały zdefiniowane
mnoznik = 3
pomnoz_przez = fn liczba -> liczba * mnoznik end
IO.puts("7 * 3 = #{pomnoz_przez.(7)}")

# Zmiana zewnętrznej zmiennej nie wpływa na wartość przechwyconą przez funkcję
mnoznik = 5
IO.puts("7 * 3 (nadal 3, mimo zmiany mnoznika na 5) = #{pomnoz_przez.(7)}")

# ------ Przekazywanie funkcji jako argumentów ------
IO.puts("\n--- Przekazywanie funkcji jako argumentów ---")

defmodule Mapper do
  def map([], _func), do: []
  def map([head | tail], func) do
    [func.(head) | map(tail, func)]
  end
end

lista = [1, 2, 3, 4, 5]
podwoj = fn x -> x * 2 end
potrojne = Mapper.map(lista, podwoj)
IO.puts("Oryginalna lista: #{inspect(lista)}")
IO.puts("Po podwojeniu: #{inspect(potrojne)}")

# Przekazanie funkcji inline
kwadraty = Mapper.map(lista, fn x -> x * x end)
IO.puts("Kwadraty liczb: #{inspect(kwadraty)}")

# ------ Skrócona składnia (&) ------
IO.puts("\n--- Skrócona składnia (&) ---")

# Dla prostych funkcji można używać skróconej składni
dodaj_skrocona = &(&1 + &2)
IO.puts("2 + 3 = #{dodaj_skrocona.(2, 3)}")

# &1, &2, itd. to pozycyjne zmienne reprezentujące parametry
pomnoz_skrocona = &(&1 * &2)
IO.puts("4 * 5 = #{pomnoz_skrocona.(4, 5)}")

# Przykłady bardziej złożonych funkcji
kwadrat = &(&1 * &1)
IO.puts("Kwadrat z 4: #{kwadrat.(4)}")

dodaj_jeden_i_pomnoz = &((&1 + 1) * &2)
IO.puts("(5 + 1) * 3 = #{dodaj_jeden_i_pomnoz.(5, 3)}")

# Jeszcze bardziej skrócona składnia
lista = [1, 2, 3, 4, 5]
IO.puts("Lista liczb powiększonych o 1: #{inspect(Enum.map(lista, &(&1 + 1)))}")
IO.puts("Lista podwojonych liczb: #{inspect(Enum.map(lista, &(&1 * 2)))}")

# ------ Funkcje anonimowe z pattern matching ------
IO.puts("\n--- Funkcje anonimowe z pattern matching ---")

# Funkcja anonimowa z pattern matching na argumentach
lista_handler = fn
  [] -> "Lista pusta"
  [x] -> "Lista z jednym elementem: #{x}"
  [x, y] -> "Lista z dwoma elementami: #{x} i #{y}"
  [h | t] -> "Lista zaczynająca się od #{h} z #{length(t)} dodatkowymi elementami"
end

IO.puts(lista_handler.([]))
IO.puts(lista_handler.([1]))
IO.puts(lista_handler.([1, 2]))
IO.puts(lista_handler.([1, 2, 3, 4]))

# Funkcja z guards
check_type = fn
  x when is_integer(x) -> "#{x} jest liczbą całkowitą"
  x when is_float(x) -> "#{x} jest liczbą zmiennoprzecinkową"
  x when is_binary(x) -> "#{inspect(x)} jest stringiem"
  x when is_atom(x) -> "#{x} jest atomem"
  _ -> "Inny typ danych"
end

IO.puts(check_type.(42))
IO.puts(check_type.(3.14))
IO.puts(check_type.("tekst"))
IO.puts(check_type.(:atom))
IO.puts(check_type.([1, 2, 3]))

# ------ Zastosowania funkcji anonimowych ------
IO.puts("\n--- Zastosowania funkcji anonimowych ---")

# 1. Filtrowanie danych
lista = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
parzyste = Enum.filter(lista, fn x -> rem(x, 2) == 0 end)
IO.puts("Liczby parzyste: #{inspect(parzyste)}")

# 2. Transformacja danych
kwadraty = Enum.map(lista, fn x -> x * x end)
IO.puts("Kwadraty liczb: #{inspect(kwadraty)}")

# 3. Sortowanie z własnym komparatorem
slowa = ["jabłko", "gruszka", "wiśnia", "śliwka", "malina"]
posortowane_po_dlugosci = Enum.sort(slowa, fn a, b -> String.length(a) <= String.length(b) end)
IO.puts("Słowa posortowane po długości: #{inspect(posortowane_po_dlugosci)}")

# 4. Redukcja (foldowanie) danych
suma = Enum.reduce(lista, 0, fn x, acc -> acc + x end)
IO.puts("Suma wszystkich liczb: #{suma}")

# 5. Funkcja wyższego rzędu zwracająca inną funkcję
defmodule FunkcjeWyzszegoRzedu do
  def stworz_mnoznik(n) do
    fn x -> x * n end
  end
end

pomnoz_przez_5 = FunkcjeWyzszegoRzedu.stworz_mnoznik(5)
IO.puts("7 * 5 = #{pomnoz_przez_5.(7)}")

pomnoz_przez_10 = FunkcjeWyzszegoRzedu.stworz_mnoznik(10)
IO.puts("3 * 10 = #{pomnoz_przez_10.(3)}")

# ------ Partycja funkcji (partial application) ------
IO.puts("\n--- Partycja funkcji ---")

defmodule Partycja do
  def zastosuj_czesciowo(funkcja, arg1) do
    fn arg2 -> funkcja.(arg1, arg2) end
  end
end

dodawanie = fn a, b -> a + b end
dodaj_5 = Partycja.zastosuj_czesciowo(dodawanie, 5)
IO.puts("5 + 10 = #{dodaj_5.(10)}")

# Praktyczny przykład partycji
formatuj_walute = fn kwota, waluta -> "#{kwota} #{waluta}" end
formatuj_pln = fn kwota -> formatuj_walute.(kwota, "PLN") end
formatuj_eur = fn kwota -> formatuj_walute.(kwota, "EUR") end

IO.puts(formatuj_pln.(100))
IO.puts(formatuj_eur.(50))

# ------ Zakończenie ------
IO.puts("\nTo podsumowuje funkcje anonimowe w Elixir!")
