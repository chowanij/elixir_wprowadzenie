# Dopasowanie wzorców (Pattern Matching) w funkcjach Elixir

IO.puts("=== Dopasowanie wzorców w funkcjach ===\n")

# ------ Podstawy pattern matchingu w funkcjach ------
IO.puts("--- Podstawy pattern matchingu w funkcjach ---")

defmodule PrzykladyDopasowania do
  # Wieloklauzulowe funkcje z różnymi wzorcami
  def powitaj([]), do: "Witaj nieznajomy!"
  def powitaj([imie]), do: "Witaj #{imie}!"
  def powitaj([imie, nazwisko]), do: "Witaj #{imie} #{nazwisko}!"
  def powitaj([imie, nazwisko | _reszta]), do: "Witaj #{imie} #{nazwisko} i wszyscy inni!"

  # Dopasowanie do konkretnych wartości
  def dzien_tygodnia(1), do: "Poniedziałek"
  def dzien_tygodnia(2), do: "Wtorek"
  def dzien_tygodnia(3), do: "Środa"
  def dzien_tygodnia(4), do: "Czwartek"
  def dzien_tygodnia(5), do: "Piątek"
  def dzien_tygodnia(6), do: "Sobota"
  def dzien_tygodnia(7), do: "Niedziela"
  def dzien_tygodnia(_), do: "Nieprawidłowy dzień tygodnia"

  # Dopasowanie do tuple (krotki)
  def opisz_punkt({0, 0}), do: "Punkt początkowy (0,0)"
  def opisz_punkt({0, y}), do: "Punkt na osi Y (0,#{y})"
  def opisz_punkt({x, 0}), do: "Punkt na osi X (#{x},0)"
  def opisz_punkt({x, y}), do: "Punkt o współrzędnych (#{x},#{y})"

  # Dopasowanie do map
  def opisz_osobe(%{imie: imie, wiek: wiek}), do: "#{imie} ma #{wiek} lat"
  def opisz_osobe(%{imie: imie}), do: "#{imie}, wiek nieznany"
  def opisz_osobe(_), do: "Nieznana osoba"
end

IO.puts(PrzykladyDopasowania.powitaj([]))
IO.puts(PrzykladyDopasowania.powitaj(["Jan"]))
IO.puts(PrzykladyDopasowania.powitaj(["Jan", "Kowalski"]))
IO.puts(PrzykladyDopasowania.powitaj(["Jan", "Kowalski", "Jr.", "Dr."]))

IO.puts("\nDzień tygodnia 3: #{PrzykladyDopasowania.dzien_tygodnia(3)}")
IO.puts("Dzień tygodnia 7: #{PrzykladyDopasowania.dzien_tygodnia(7)}")
IO.puts("Dzień tygodnia 8: #{PrzykladyDopasowania.dzien_tygodnia(8)}")

IO.puts("\nOpis punktu (0,0): #{PrzykladyDopasowania.opisz_punkt({0, 0})}")
IO.puts("Opis punktu (5,0): #{PrzykladyDopasowania.opisz_punkt({5, 0})}")
IO.puts("Opis punktu (0,7): #{PrzykladyDopasowania.opisz_punkt({0, 7})}")
IO.puts("Opis punktu (2,3): #{PrzykladyDopasowania.opisz_punkt({2, 3})}")

osoba1 = %{imie: "Anna", wiek: 28}
osoba2 = %{imie: "Piotr"}
IO.puts("\nOpis osoby 1: #{PrzykladyDopasowania.opisz_osobe(osoba1)}")
IO.puts("Opis osoby 2: #{PrzykladyDopasowania.opisz_osobe(osoba2)}")
IO.puts("Opis pustej mapy: #{PrzykladyDopasowania.opisz_osobe(%{})}")

# ------ Strażnicy (Guards) ------
IO.puts("\n--- Strażnicy (Guards) ---")

defmodule Matematyka do
  def dziel(a, b) when b != 0, do: a / b
  def dziel(_, 0), do: "Nie można dzielić przez zero"

  def porownaj(a, b) when a > b, do: "#{a} jest większe od #{b}"
  def porownaj(a, b) when a < b, do: "#{a} jest mniejsze od #{b}"
  def porownaj(a, b) when a == b, do: "#{a} jest równe #{b}"

  # Złożone warunki w strażnikach
  def opisz_liczbe(x) when is_integer(x) and x > 0, do: "Dodatnia liczba całkowita"
  def opisz_liczbe(x) when is_integer(x) and x < 0, do: "Ujemna liczba całkowita"
  def opisz_liczbe(0), do: "Zero"
  def opisz_liczbe(x) when is_float(x), do: "Liczba zmiennoprzecinkowa"
  def opisz_liczbe(_), do: "Nie liczba"

  # Przedziały wartości w strażnikach
  def ocena_punkty(punkty) when punkty >= 90, do: "5"
  def ocena_punkty(punkty) when punkty >= 75 and punkty < 90, do: "4"
  def ocena_punkty(punkty) when punkty >= 60 and punkty < 75, do: "3"
  def ocena_punkty(punkty) when punkty >= 50 and punkty < 60, do: "2"
  def ocena_punkty(punkty) when punkty >= 0 and punkty < 50, do: "1"
  def ocena_punkty(_), do: "Nieprawidłowa liczba punktów"
end

IO.puts("10 / 2 = #{Matematyka.dziel(10, 2)}")
IO.puts("10 / 0 = #{Matematyka.dziel(10, 0)}")

IO.puts("\nPorównanie 5 i 3: #{Matematyka.porownaj(5, 3)}")
IO.puts("Porównanie 2 i 7: #{Matematyka.porownaj(2, 7)}")
IO.puts("Porównanie 4 i 4: #{Matematyka.porownaj(4, 4)}")

IO.puts("\nOpis liczby 42: #{Matematyka.opisz_liczbe(42)}")
IO.puts("Opis liczby -10: #{Matematyka.opisz_liczbe(-10)}")
IO.puts("Opis liczby 0: #{Matematyka.opisz_liczbe(0)}")
IO.puts("Opis liczby 3.14: #{Matematyka.opisz_liczbe(3.14)}")
IO.puts("Opis wartości \"abc\": #{Matematyka.opisz_liczbe("abc")}")

IO.puts("\nOcena za 95 punktów: #{Matematyka.ocena_punkty(95)}")
IO.puts("Ocena za 82 punktów: #{Matematyka.ocena_punkty(82)}")
IO.puts("Ocena za 65 punktów: #{Matematyka.ocena_punkty(65)}")
IO.puts("Ocena za 55 punktów: #{Matematyka.ocena_punkty(55)}")
IO.puts("Ocena za 42 punktów: #{Matematyka.ocena_punkty(42)}")
IO.puts("Ocena za -5 punktów: #{Matematyka.ocena_punkty(-5)}")

# ------ Pattern matching w parametrach funkcji ------
IO.puts("\n--- Pattern matching w parametrach funkcji ---")

defmodule ListyOperacje do
  # Rekursja z wykorzystaniem pattern matching
  def suma([]), do: 0
  def suma([glowa | ogon]), do: glowa + suma(ogon)

  # Przetwarzanie pierwszych elementów
  def pierwsze_dwa([]), do: nil
  def pierwsze_dwa([el]), do: [el]
  def pierwsze_dwa([el1, el2 | _]), do: [el1, el2]

  # Ignorowanie części parametrów
  def pierwszy_element([pierwszy | _]), do: pierwszy
  def ostatni_element([ostatni]), do: ostatni
  def ostatni_element([_ | ogon]), do: ostatni_element(ogon)
end

lista = [1, 2, 3, 4, 5]
IO.puts("Suma elementów [1,2,3,4,5]: #{ListyOperacje.suma(lista)}")
IO.puts("Pierwsze dwa elementy [1,2,3,4,5]: #{inspect(ListyOperacje.pierwsze_dwa(lista))}")
IO.puts("Pierwszy element [1,2,3,4,5]: #{ListyOperacje.pierwszy_element(lista)}")
IO.puts("Ostatni element [1,2,3,4,5]: #{ListyOperacje.ostatni_element(lista)}")

# ------ Zagnieżdżone pattern matching ------
IO.puts("\n--- Zagnieżdżone pattern matching ---")

defmodule ZlozoneStrukturyDanych do
  # Zagnieżdżone listy
  def pierwszy_z_podlisty([[], _ | _]), do: nil
  def pierwszy_z_podlisty([[pierwszy | _] | _]), do: pierwszy
  def pierwszy_z_podlisty(_), do: nil

  # Zagnieżdżone tuple
  def wydobadz_info({imie, {dzien, miesiac, rok}, miasto}) do
    "#{imie}, urodzony #{dzien}.#{miesiac}.#{rok} w miejscowości #{miasto}"
  end
  def wydobadz_info(_), do: "Nieprawidłowe dane"

  # Zagnieżdżone mapy
  def adres_uzytkownika(%{osoba: %{adres: %{miasto: miasto, ulica: ulica}}}) do
    "Adres: #{ulica}, #{miasto}"
  end
  def adres_uzytkownika(_), do: "Brak danych adresowych"
end

lista_list = [[1, 2, 3], [4, 5], [6, 7, 8]]
IO.puts("Pierwszy element pierwszej podlisty: #{ZlozoneStrukturyDanych.pierwszy_z_podlisty(lista_list)}")
IO.puts("Pierwszy element z [[], [4, 5]]: #{ZlozoneStrukturyDanych.pierwszy_z_podlisty([[], [4, 5]])}")

osoba = {"Jan Kowalski", {15, 4, 1985}, "Warszawa"}
IO.puts("\nInformacje o osobie: #{ZlozoneStrukturyDanych.wydobadz_info(osoba)}")

uzytkownik = %{
  osoba: %{
    imie: "Anna",
    nazwisko: "Nowak",
    adres: %{
      miasto: "Kraków",
      ulica: "Długa 10"
    }
  }
}
IO.puts("\nAdres użytkownika: #{ZlozoneStrukturyDanych.adres_uzytkownika(uzytkownik)}")

# ------ Zakończenie ------
IO.puts("\nTo podsumowuje dopasowanie wzorców (pattern matching) w Elixirze!")
