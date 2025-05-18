# Operacje na zagnieżdżonych kolekcjach w Elixir

IO.puts("=== Operacje na zagnieżdżonych kolekcjach w Elixir ===\n")

# ------ Zagnieżdżone listy ------
IO.puts("--- Zagnieżdżone listy ---")

# Przykład zagnieżdżonej listy (macierz 3x3)
macierz = [
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9]
]
IO.puts("Macierz 3x3: #{inspect(macierz)}")

# Dostęp do elementów zagnieżdżonej listy
element = macierz |> Enum.at(1) |> Enum.at(2)
IO.puts("Element [1][2]: #{element}")

# Spłaszczanie zagnieżdżonych list
splaszczona = List.flatten(macierz)
IO.puts("Spłaszczona macierz: #{inspect(splaszczona)}")

# Transformacja każdego elementu zagnieżdżonej listy
macierz_podwojona = Enum.map(macierz, fn wiersz ->
  Enum.map(wiersz, fn element -> element * 2 end)
end)
IO.puts("Macierz z podwojonymi elementami: #{inspect(macierz_podwojona)}")

# ------ Zagnieżdżone mapy ------
IO.puts("\n--- Zagnieżdżone mapy ---")

# Przykład zagnieżdżonej mapy (struktura JSON-podobna)
dane_osoby = %{
  imie: "Jan",
  nazwisko: "Kowalski",
  wiek: 35,
  adres: %{
    ulica: "Krakowska 10",
    miasto: "Warszawa",
    kod_pocztowy: "00-001"
  },
  kontakt: %{
    email: "jan@example.com",
    telefon: %{
      komorkowy: "123-456-789",
      stacjonarny: "22-123-45-67"
    }
  }
}
IO.puts("Dane osoby: #{inspect(dane_osoby)}")

# Dostęp do zagnieżdżonych danych
miasto = dane_osoby.adres.miasto
IO.puts("Miasto: #{miasto}")

telefon_komorkowy = dane_osoby.kontakt.telefon.komorkowy
IO.puts("Telefon komórkowy: #{telefon_komorkowy}")

# Aktualizacja zagnieżdżonych danych
zaktualizowane_dane = put_in(dane_osoby.adres.miasto, "Kraków")
IO.puts("Zaktualizowane miasto: #{zaktualizowane_dane.adres.miasto}")

# Aktualizacja zagnieżdżonych danych za pomocą update_in
dane_z_nowym_telefonem = update_in(dane_osoby.kontakt.telefon.komorkowy, fn _ -> "999-888-777" end)
IO.puts("Nowy telefon komórkowy: #{dane_z_nowym_telefonem.kontakt.telefon.komorkowy}")

# ------ Operacje na zagnieżdżonych strukturach danych ------
IO.puts("\n--- Operacje na zagnieżdżonych strukturach danych ---")

# Definiowanie struktur
defmodule Adres do
  defstruct [:ulica, :miasto, :kod_pocztowy]
end

defmodule Kontakt do
  defstruct [:email, :telefon]
end

defmodule Osoba do
  defstruct [:imie, :nazwisko, :wiek, :adres, :kontakt]
end

# Tworzenie zagnieżdżonych struktur
adres = %Adres{
  ulica: "Długa 15",
  miasto: "Gdańsk",
  kod_pocztowy: "80-001"
}

kontakt = %Kontakt{
  email: "anna@example.com",
  telefon: %{
    komorkowy: "555-123-456",
    stacjonarny: "58-987-65-43"
  }
}

osoba = %Osoba{
  imie: "Anna",
  nazwisko: "Nowak",
  wiek: 28,
  adres: adres,
  kontakt: kontakt
}

IO.puts("Osoba: #{inspect(osoba)}")

# Aktualizacja zagnieżdżonej struktury
osoba_zaktualizowana = %Osoba{osoba | adres: %Adres{osoba.adres | miasto: "Sopot"}}
IO.puts("Zaktualizowane miasto: #{osoba_zaktualizowana.adres.miasto}")

# ------ Zagnieżdżone krotki ------
IO.puts("\n--- Zagnieżdżone krotki ---")

# Drzewo binarne reprezentowane przez zagnieżdżone krotki
drzewo = {:wezel, "A",
  {:wezel, "B",
    {:lisc, "D"},
    {:lisc, "E"}
  },
  {:wezel, "C",
    {:lisc, "F"},
    {:lisc, "G"}
  }
}

IO.puts("Drzewo binarne: #{inspect(drzewo)}")

# Funkcja do przechodzenia drzewa (preorder)
defmodule DrzewoBinarne do
  def preorder({:lisc, wartosc}) do
    [wartosc]
  end

  def preorder({:wezel, wartosc, lewy, prawy}) do
    [wartosc] ++ preorder(lewy) ++ preorder(prawy)
  end
end

preorder_wynik = DrzewoBinarne.preorder(drzewo)
IO.puts("Przejście preorder: #{inspect(preorder_wynik)}")

# ------ Zagnieżdżone listy krotek (tabele danych) ------
IO.puts("\n--- Zagnieżdżone listy krotek (tabele danych) ---")

# Tabela danych jako lista krotek
tabela_danych = [
  {"Jan", "Kowalski", 35, "Programista"},
  {"Anna", "Nowak", 28, "Designer"},
  {"Piotr", "Wiśniewski", 42, "Manager"},
  {"Ewa", "Dąbrowska", 31, "Tester"}
]

IO.puts("Tabela danych: #{inspect(tabela_danych)}")

# Filtrowanie danych
programisci = Enum.filter(tabela_danych, fn {_, _, _, zawod} -> zawod == "Programista" end)
IO.puts("Programiści: #{inspect(programisci)}")

# Transformacja danych - wyodrębnienie imion i nazwisk
imiona_nazwiska = Enum.map(tabela_danych, fn {imie, nazwisko, _, _} -> "#{imie} #{nazwisko}" end)
IO.puts("Imiona i nazwiska: #{inspect(imiona_nazwiska)}")

# Sortowanie danych
posortowani_wg_wieku = Enum.sort_by(tabela_danych, fn {_, _, wiek, _} -> wiek end)
IO.puts("Posortowani według wieku: #{inspect(posortowani_wg_wieku)}")

# ------ Zagnieżdżone listy map ------
IO.puts("\n--- Zagnieżdżone listy map ---")

# Lista zagnieżdżonych map (dane JSON-podobne)
pracownicy = [
  %{
    id: 1,
    imie: "Jan",
    nazwisko: "Kowalski",
    umiejetnosci: [
      %{nazwa: "Elixir", poziom: "zaawansowany"},
      %{nazwa: "JavaScript", poziom: "średni"},
      %{nazwa: "SQL", poziom: "podstawowy"}
    ]
  },
  %{
    id: 2,
    imie: "Anna",
    nazwisko: "Nowak",
    umiejetnosci: [
      %{nazwa: "Python", poziom: "zaawansowany"},
      %{nazwa: "Elixir", poziom: "średni"},
      %{nazwa: "HTML/CSS", poziom: "zaawansowany"}
    ]
  }
]

IO.puts("Pracownicy z umiejętnościami: #{inspect(pracownicy)}")

# Wyodrębnienie wszystkich umiejętności
wszystkie_umiejetnosci = Enum.flat_map(pracownicy, fn pracownik ->
  Enum.map(pracownik.umiejetnosci, fn umiejetnosc -> umiejetnosc.nazwa end)
end)
IO.puts("Wszystkie umiejętności: #{inspect(wszystkie_umiejetnosci)}")

# Znalezienie pracowników z określoną umiejętnością
znajdz_z_umiejetnoscia = fn nazwa_umiejetnosci ->
  Enum.filter(pracownicy, fn pracownik ->
    Enum.any?(pracownik.umiejetnosci, fn umiejetnosc -> umiejetnosc.nazwa == nazwa_umiejetnosci end)
  end)
end

elixir_devs = znajdz_z_umiejetnoscia.("Elixir")
IO.puts("Pracownicy znający Elixir: #{inspect(Enum.map(elixir_devs, fn dev -> dev.imie end))}")

# ------ Funkcje pomocnicze do pracy z zagnieżdżonymi strukturami ------
IO.puts("\n--- Funkcje pomocnicze do pracy z zagnieżdżonymi strukturami ---")

# get_in, put_in, update_in - dostęp do zagnieżdżonych struktur
zagniezdzona_mapa = %{
  a: %{
    b: %{
      c: 1,
      d: 2
    },
    e: 3
  },
  f: 4
}

# Dostęp do zagnieżdżonej wartości
wartosc_c = get_in(zagniezdzona_mapa, [:a, :b, :c])
IO.puts("Wartość c: #{wartosc_c}")

# Aktualizacja zagnieżdżonej wartości
zaktualizowana_mapa = put_in(zagniezdzona_mapa, [:a, :b, :c], 100)
IO.puts("Zaktualizowana wartość c: #{get_in(zaktualizowana_mapa, [:a, :b, :c])}")

# Aktualizacja z funkcją
mapa_z_podwojona_wartoscia = update_in(zagniezdzona_mapa, [:a, :b, :d], fn x -> x * 2 end)
IO.puts("Podwojona wartość d: #{get_in(mapa_z_podwojona_wartoscia, [:a, :b, :d])}")

# Dostęp dynamiczny (gdy klucze są zmiennymi)
klucz_a = :a
klucz_b = :b
klucz_c = :c

wartosc_dynamiczna = get_in(zagniezdzona_mapa, [klucz_a, klucz_b, klucz_c])
IO.puts("Wartość dynamiczna: #{wartosc_dynamiczna}")

IO.puts("\nTo podsumowuje operacje na zagnieżdżonych kolekcjach w Elixir!")
