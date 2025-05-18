# Funkcje rekurencyjne w Elixir

IO.puts("=== Funkcje rekurencyjne w Elixir ===\n")

# ------ Podstawy rekurencji ------
IO.puts("--- Podstawy rekurencji ---")

defmodule Rekurencja do
  def silnia(0), do: 1
  def silnia(n) when n > 0, do: n * silnia(n - 1)

  # Rekurencyjne sumowanie listy
  def suma([]), do: 0
  def suma([glowa | ogon]), do: glowa + suma(ogon)

  # Rekurencyjna długość listy
  def dlugosc([]), do: 0
  def dlugosc([_ | ogon]), do: 1 + dlugosc(ogon)
end

IO.puts("Silnia 5: #{Rekurencja.silnia(5)}")
IO.puts("Silnia 0: #{Rekurencja.silnia(0)}")

lista = [1, 2, 3, 4, 5]
IO.puts("\nSuma elementów listy: #{Rekurencja.suma(lista)}")
IO.puts("Długość listy: #{Rekurencja.dlugosc(lista)}")

# ------ Rekurencja ogonowa (tail recursion) ------
IO.puts("\n--- Rekurencja ogonowa ---")

defmodule RekurencjaOgonowa do
  # Standardowa rekurencja
  def silnia_std(0), do: 1
  def silnia_std(n) when n > 0, do: n * silnia_std(n - 1)

  # Rekurencja ogonowa z akumulatorem
  def silnia_ogonowa(n), do: silnia_ogonowa(n, 1)
  defp silnia_ogonowa(0, acc), do: acc
  defp silnia_ogonowa(n, acc) when n > 0, do: silnia_ogonowa(n - 1, n * acc)

  # Sumowanie listy - rekurencja ogonowa
  def suma(lista), do: suma(lista, 0)
  defp suma([], acc), do: acc
  defp suma([glowa | ogon], acc), do: suma(ogon, acc + glowa)

  # Porównanie obu metod
  def wyjasnij_roznice, do:
  """
  Silnia standardowa: silnia_std(n) = n * silnia_std(n-1), wymaga przechowywania każdego wywołania na stosie.
  Silnia ogonowa: silnia_ogonowa(n, acc) = silnia_ogonowa(n-1, n*acc), wymaga tylko jednego rekordu aktywacji.

  Rekurencja ogonowa jest optymalizowana przez kompilator, co zmniejsza zużycie pamięci.
  """
end

IO.puts("Silnia 5 (standardowa rekurencja): #{RekurencjaOgonowa.silnia_std(5)}")
IO.puts("Silnia 5 (rekurencja ogonowa): #{RekurencjaOgonowa.silnia_ogonowa(5)}")
IO.puts("Suma listy [1,2,3,4,5]: #{RekurencjaOgonowa.suma([1, 2, 3, 4, 5])}")
IO.puts("\nRóżnica między standardową a ogonową rekurencją:")
IO.puts(RekurencjaOgonowa.wyjasnij_roznice)

# ------ Przykłady zaawansowane ------
IO.puts("\n--- Zaawansowane przykłady ---")

defmodule ZaawansowanaRekurencja do
  # Ciąg Fibonacciego - standardowa rekurencja
  def fib_std(0), do: 0
  def fib_std(1), do: 1
  def fib_std(n) when n > 1, do: fib_std(n - 1) + fib_std(n - 2)

  # Ciąg Fibonacciego - rekurencja ogonowa
  def fib(n), do: fib(n, 0, 1)
  defp fib(0, _a, _b), do: 0
  defp fib(1, _a, b), do: b
  defp fib(n, a, b) when n > 1, do: fib(n - 1, b, a + b)

  # Wyszukiwanie binarne rekurencyjne
  def szukaj_binarnie([], _wartosc), do: nil
  def szukaj_binarnie(lista, wartosc) do
    srodkowy_indeks = div(length(lista), 2)
    srodkowy_element = Enum.at(lista, srodkowy_indeks)

    cond do
      srodkowy_element == wartosc ->
        srodkowy_indeks
      srodkowy_element > wartosc ->
        lewa_czesc = Enum.slice(lista, 0, srodkowy_indeks)
        szukaj_binarnie(lewa_czesc, wartosc)
      srodkowy_element < wartosc ->
        prawa_czesc = Enum.slice(lista, srodkowy_indeks + 1, length(lista) - srodkowy_indeks - 1)
        wynik = szukaj_binarnie(prawa_czesc, wartosc)
        if wynik == nil, do: nil, else: srodkowy_indeks + 1 + wynik
    end
  end

  # QuickSort - rekurencyjny algorytm sortowania
  def quicksort([]), do: []
  def quicksort([pivot | reszta]) do
    {mniejsze, wieksze} = Enum.split_with(reszta, fn x -> x <= pivot end)
    quicksort(mniejsze) ++ [pivot] ++ quicksort(wieksze)
  end

  # Spłaszczanie zagnieżdżonych list - rekurencyjnie
  def splaszcz([]), do: []
  def splaszcz([glowa | ogon]) when is_list(glowa), do: splaszcz(glowa) ++ splaszcz(ogon)
  def splaszcz([glowa | ogon]), do: [glowa | splaszcz(ogon)]
end

IO.puts("Fibonacci(10) - rekurencja standardowa: #{ZaawansowanaRekurencja.fib_std(10)}")
IO.puts("Fibonacci(10) - rekurencja ogonowa: #{ZaawansowanaRekurencja.fib(10)}")

posortowana_lista = [1, 3, 5, 7, 9, 11, 13, 15]
IO.puts("\nSzukanie wartości 7 w liście #{inspect(posortowana_lista)}: #{ZaawansowanaRekurencja.szukaj_binarnie(posortowana_lista, 7)}")
IO.puts("Szukanie wartości 12 w liście: #{inspect(ZaawansowanaRekurencja.szukaj_binarnie(posortowana_lista, 12))}")

nieposortowana_lista = [5, 2, 9, 1, 7, 6, 3]
IO.puts("\nPrzed sortowaniem: #{inspect(nieposortowana_lista)}")
IO.puts("Po sortowaniu: #{inspect(ZaawansowanaRekurencja.quicksort(nieposortowana_lista))}")

zagniezdzona_lista = [1, [2, [3, 4], 5], [6, 7]]
IO.puts("\nPrzed spłaszczeniem: #{inspect(zagniezdzona_lista)}")
IO.puts("Po spłaszczeniu: #{inspect(ZaawansowanaRekurencja.splaszcz(zagniezdzona_lista))}")

# ------ Uważaj na limity stosu ------
IO.puts("\n--- Limity stosu i wydajność ---")

defmodule PoradyRekurencji do
  def porady do
    """
    1. Używaj rekurencji ogonowej dla długich sekwencji, aby uniknąć przepełnienia stosu
    2. Monitoruj zużycie pamięci w rekurencyjnych algorytmach
    3. Dla dużych danych wejściowych rozważ rozwiązania iteracyjne lub biblioteczne
    4. Niektóre algorytmy wydajniejsze są z rekurencją standardową, inne z ogonową
    5. Elixir optymalizuje rekurencję ogonową (ostatnie wywołanie funkcji)
    6. Użyj profilowania do porównania wydajności różnych implementacji
    """
  end

  # Przykład kodu, który może prowadzić do przepełnienia stosu
  def przyklad_bledu(n) when n > 0 do
    IO.puts("Ten kod może spowodować przepełnienie stosu przy dużych wartościach n: #{n}")
    # Gdybyśmy uruchomili ten kod z bardzo dużym n, mógłby spowodować przepełnienie:
    # przyklad_bledu(n - 1)
  end
  def przyklad_bledu(0), do: :ok
end

IO.puts(PoradyRekurencji.porady())
PoradyRekurencji.przyklad_bledu(5)

# ------ Zakończenie ------
IO.puts("\nTo podsumowuje funkcje rekurencyjne w Elixirze!")
