# Krotki w Elixir

IO.puts("=== Krotki w Elixir ===\n")

# ------ Tworzenie krotek ------
IO.puts("--- Tworzenie krotek ---")

# Pusta krotka
krotka_pusta = {}
IO.puts("Pusta krotka: #{inspect(krotka_pusta)}")

# Krotka z jednym elementem
krotka_jednoelementowa = {42}
IO.puts("Krotka z jednym elementem: #{inspect(krotka_jednoelementowa)}")

# Krotka z wieloma elementami
osoba = {"Jan", "Kowalski", 30}
IO.puts("Osoba (krotka): #{inspect(osoba)}")

# Krotka z różnymi typami danych
mieszana = {"tekst", :atom, 123, 3.14, [1, 2, 3], {"zagnieżdżona"}}
IO.puts("Krotka mieszana: #{inspect(mieszana)}")

# ------ Dostęp do elementów krotki ------
IO.puts("\n--- Dostęp do elementów krotki ---")

# Dostęp do elementu za pomocą elem/2
imie = elem(osoba, 0)
IO.puts("Imię osoby: #{imie}")

nazwisko = elem(osoba, 1)
IO.puts("Nazwisko osoby: #{nazwisko}")

wiek = elem(osoba, 2)
IO.puts("Wiek osoby: #{wiek}")

# ------ Pattern matching z krotkami ------
IO.puts("\n--- Pattern matching z krotkami ---")

# Dopasowanie krotki do wzorca
{imie_dopasowane, nazwisko_dopasowane, wiek_dopasowany} = osoba
IO.puts("Dopasowane wartości: imię=#{imie_dopasowane}, nazwisko=#{nazwisko_dopasowane}, wiek=#{wiek_dopasowany}")

# Dopasowanie z ignorowaniem niektórych wartości
{nowe_imie, _, _} = osoba
IO.puts("Dopasowane tylko imię: #{nowe_imie}")

# Dopasowanie zagnieżdżonych krotek
{{x, y}, {z}} = {{1, 2}, {3}}
IO.puts("Dopasowane współrzędne: x=#{x}, y=#{y}, z=#{z}")

# Dopasowanie w głowie funkcji (przykład)
defmodule KrotkaDemo do
  def wypisz_osobe({imie, nazwisko, wiek}) do
    "Osoba: #{imie} #{nazwisko}, #{wiek} lat"
  end
end

wynik = KrotkaDemo.wypisz_osobe(osoba)
IO.puts("Funkcja z dopasowaniem: #{wynik}")

# ------ Modyfikacja krotek ------
IO.puts("\n--- Modyfikacja krotek (niezmienność) ---")

# Tworzymy nową krotkę na podstawie istniejącej
krotka_oryginalna = {1, 2, 3}
krotka_zmodyfikowana = put_elem(krotka_oryginalna, 1, 42)
IO.puts("Krotka oryginalna: #{inspect(krotka_oryginalna)}")
IO.puts("Krotka zmodyfikowana: #{inspect(krotka_zmodyfikowana)}")

# ------ Konwencje używania krotek ------
IO.puts("\n--- Konwencje używania krotek ---")

# 1. Małe stałe kolekcje o znanej liczbie elementów
punkt_2d = {10, 20}
punkt_3d = {10, 20, 30}
IO.puts("Punkty - 2D: #{inspect(punkt_2d)}, 3D: #{inspect(punkt_3d)}")

# 2. Zwracanie statusu operacji
defmodule Status do
  def dzielenie(a, 0), do: {:error, "Dzielenie przez zero"}
  def dzielenie(a, b), do: {:ok, a / b}
end

case Status.dzielenie(10, 2) do
  {:ok, wynik} -> IO.puts("Wynik dzielenia: #{wynik}")
  {:error, powod} -> IO.puts("Błąd: #{powod}")
end

case Status.dzielenie(10, 0) do
  {:ok, wynik} -> IO.puts("Wynik dzielenia: #{wynik}")
  {:error, powod} -> IO.puts("Błąd: #{powod}")
end

# 3. Krotki jako rekordy (teraz często zastępowane przez struktury)
pracownik = {:pracownik, "Anna", "Nowak", :programista, 28}

defmodule Pracownicy do
  def info({:pracownik, imie, nazwisko, stanowisko, wiek}) do
    "#{imie} #{nazwisko} (#{wiek}), stanowisko: #{stanowisko}"
  end
end

IO.puts("Informacja o pracowniku: #{Pracownicy.info(pracownik)}")

# ------ Wykorzystanie krotek w innych strukturach ------
IO.puts("\n--- Wykorzystanie krotek w innych strukturach ---")

# Listy krotek (popularne w praktyce)
pracownicy = [
  {"Jan", "Kowalski", 30},
  {"Anna", "Nowak", 28},
  {"Piotr", "Wiśniewski", 35}
]

IO.puts("Lista pracowników (krotek):")
Enum.each(pracownicy, fn {imie, nazwisko, wiek} ->
  IO.puts("  #{imie} #{nazwisko}, #{wiek} lat")
end)

# Mapy z krotkami jako kluczami (przydatne dla złożonych kluczy)
punkty_wartosci = %{
  {0, 0} => "początek",
  {10, 20} => "środek",
  {100, 100} => "koniec"
}
IO.puts("Punkt {10, 20} to: #{punkty_wartosci[{10, 20}]}")

# ------ Zagnieżdżone krotki ------
IO.puts("\n--- Zagnieżdżone krotki ---")

# Drzewo binarne jako krotki
drzewo = {:wezel, "root",
  {:wezel, "lewy", {:lisc, "lewy-lewy"}, {:lisc, "lewy-prawy"}},
  {:wezel, "prawy", {:lisc, "prawy-lewy"}, {:lisc, "prawy-prawy"}}
}

# Funkcja rekurencyjna do przetwarzania drzewa
defmodule Drzewo do
  def przejdz({:lisc, wartosc}) do
    wartosc
  end

  def przejdz({:wezel, wartosc, lewo, prawo}) do
    "#{wartosc} -> (#{przejdz(lewo)}, #{przejdz(prawo)})"
  end
end

IO.puts("Drzewo: #{Drzewo.przejdz(drzewo)}")

# ------ Wydajność krotek ------
IO.puts("\n--- Wydajność krotek ---")
IO.puts("• Dostęp do elementu po indeksie: O(1)")
IO.puts("• Modyfikacja elementu: O(n) - tworzy nową krotkę")
IO.puts("• Pamięciowo efektywne dla małych kolekcji o stałym rozmiarze")
IO.puts("• Szybkie dopasowywanie wzorców")

# ------ Różnice między krotkami a listami ------
IO.puts("\n--- Różnice między krotkami a listami ---")
IO.puts("1. Krotki mają stałą długość, listy - zmienną")
IO.puts("2. Krotki są zwykle używane dla heterogenicznych danych (różne typy)")
IO.puts("3. Listy są zwykle używane dla homogenicznych danych (ten sam typ)")
IO.puts("4. Krotki są wydajniejsze dla stałych zbiorów danych")
IO.puts("5. Listy są lepsze dla kolekcji zmiennej długości")

IO.puts("\nTo podsumowuje podstawowe operacje na krotkach w Elixir!")
