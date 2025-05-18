# Struktury w Elixir

IO.puts("=== Struktury w Elixir ===\n")

# ------ Definiowanie struktur ------
IO.puts("--- Definiowanie struktur ---")

defmodule Osoba do
  @moduledoc """
  Moduł reprezentujący osobę.
  """

  # Definiowanie struktury z domyślnymi wartościami
  defstruct imie: "", nazwisko: "", wiek: nil, email: nil
end

defmodule Ksiazka do
  @moduledoc """
  Moduł reprezentujący książkę.
  """

  # Definiowanie struktury bez domyślnych wartości
  defstruct [:tytul, :autor, :rok_wydania, :isbn]
end

defmodule Adres do
  @moduledoc """
  Moduł reprezentujący adres.
  """

  # Definiowanie struktury
  defstruct ulica: "", miasto: "", kod_pocztowy: ""
end

defmodule Pracownik do
  @moduledoc """
  Moduł reprezentujący pracownika z zagnieżdżoną strukturą.
  """

  # Definiowanie struktury z zagnieżdżoną strukturą
  defstruct [:imie, :nazwisko, :stanowisko, :adres, :data_zatrudnienia]
end

# ------ Tworzenie instancji struktur ------
IO.puts("\n--- Tworzenie instancji struktur ---")

# Tworzenie struktury Osoba (używamy wszystkich domyślnych wartości)
osoba1 = %Osoba{}
IO.puts("Osoba1 (domyślna): #{inspect(osoba1)}")

# Tworzenie struktury Osoba (z określonymi wartościami)
osoba2 = %Osoba{imie: "Jan", nazwisko: "Kowalski", wiek: 30}
IO.puts("Osoba2: #{inspect(osoba2)}")

# Tworzenie struktury Ksiazka
ksiazka = %Ksiazka{tytul: "Władca Pierścieni", autor: "J.R.R. Tolkien", rok_wydania: 1954}
IO.puts("Książka: #{inspect(ksiazka)}")

# Tworzenie struktury zagnieżdżonej
adres = %Adres{ulica: "Marszałkowska 1", miasto: "Warszawa", kod_pocztowy: "00-001"}
pracownik = %Pracownik{
  imie: "Anna",
  nazwisko: "Nowak",
  stanowisko: "Programista",
  adres: adres,
  data_zatrudnienia: ~D[2022-01-15]
}
IO.puts("Pracownik: #{inspect(pracownik)}")

# ------ Dostęp do pól struktury ------
IO.puts("\n--- Dostęp do pól struktury ---")

# Dostęp do pola za pomocą .
imie = osoba2.imie
IO.puts("Imię osoby: #{imie}")

# Dostęp do zagnieżdżonej struktury
miasto_pracownika = pracownik.adres.miasto
IO.puts("Miasto pracownika: #{miasto_pracownika}")

# ------ Aktualizacja struktur ------
IO.puts("\n--- Aktualizacja struktur ---")

# Aktualizacja pola
zaktualizowana_osoba = %Osoba{osoba2 | wiek: 31}
IO.puts("Osoba po aktualizacji wieku: #{inspect(zaktualizowana_osoba)}")

# Aktualizacja zagnieżdżonej struktury
zaktualizowany_pracownik = %Pracownik{pracownik | adres: %Adres{pracownik.adres | miasto: "Kraków"}}
IO.puts("Pracownik po aktualizacji miasta: #{inspect(zaktualizowany_pracownik)}")

# ------ Różnice między strukturami a mapami ------
IO.puts("\n--- Różnice między strukturami a mapami ---")

IO.puts("1. Struktury mają zdefiniowany zestaw pól (nie można dodać innego)")
IO.puts("2. Struktury mają zawsze klucze będące atomami")
IO.puts("3. Struktury mają typ (nazwę modułu)")
IO.puts("4. Struktury mają dostęp do funkcji zdefiniowanych w ich module")

# ------ Pattern matching ze strukturami ------
IO.puts("\n--- Pattern matching ze strukturami ---")

# Dopasowanie struktury
%Osoba{imie: imie_wyodrebnione, nazwisko: nazwisko_wyodrebnione} = osoba2
IO.puts("Wyodrębnione imię: #{imie_wyodrebnione}, nazwisko: #{nazwisko_wyodrebnione}")

# Częściowe dopasowanie (tylko wybrane pola)
%Osoba{imie: imie_tylko} = osoba2
IO.puts("Wyodrębnione tylko imię: #{imie_tylko}")

# Dopasowanie z warunkiem w kodzie
funkcja_dopasowujaca = fn
  %Osoba{wiek: wiek} when wiek >= 18 -> "Osoba pełnoletnia"
  %Osoba{} -> "Osoba niepełnoletnia"
end

IO.puts("Osoba2 to: #{funkcja_dopasowujaca.(osoba2)}")

# ------ Dodawanie funkcji do modułów struktur ------
IO.puts("\n--- Dodawanie funkcji do modułów struktur ---")

defmodule Student do
  @moduledoc """
  Moduł reprezentujący studenta z funkcjami.
  """

  defstruct imie: "", nazwisko: "", oceny: []

  @doc """
  Inicjuje nowego studenta z imieniem i nazwiskiem.
  """
  def nowy(imie, nazwisko) do
    %Student{imie: imie, nazwisko: nazwisko, oceny: []}
  end

  @doc """
  Dodaje ocenę do studenta.
  """
  def dodaj_ocene(student, ocena) when ocena >= 2 and ocena <= 5 do
    %Student{student | oceny: student.oceny ++ [ocena]}
  end

  @doc """
  Oblicza średnią ocen studenta.
  """
  def srednia_ocen(%Student{oceny: []}), do: 0.0
  def srednia_ocen(%Student{oceny: oceny}) do
    suma = Enum.sum(oceny)
    suma / length(oceny)
  end

  @doc """
  Zwraca pełne imię i nazwisko studenta.
  """
  def pelne_imie(%Student{imie: imie, nazwisko: nazwisko}) do
    "#{imie} #{nazwisko}"
  end
end

# Korzystanie z funkcji modułu Student
student = Student.nowy("Piotr", "Wiśniewski")
IO.puts("Nowy student: #{inspect(student)}")

student = Student.dodaj_ocene(student, 4.0)
student = Student.dodaj_ocene(student, 5.0)
student = Student.dodaj_ocene(student, 3.5)
IO.puts("Student po dodaniu ocen: #{inspect(student)}")

srednia = Student.srednia_ocen(student)
IO.puts("Średnia ocen: #{srednia}")

pelne_imie = Student.pelne_imie(student)
IO.puts("Pełne imię: #{pelne_imie}")

# ------ Implementacja protokołów ------
IO.puts("\n--- Implementacja protokołów dla struktur ---")

defimpl String.Chars, for: Osoba do
  def to_string(%Osoba{imie: imie, nazwisko: nazwisko, wiek: wiek}) do
    "#{imie} #{nazwisko}, #{wiek || "wiek nieznany"}"
  end
end

# Teraz możemy używać funkcji to_string() dla naszej struktury
IO.puts("Osoba jako string: #{osoba2}")

# Implementacja własnego protokołu
defprotocol MozliwosciWyswietlania do
  @doc """
  Zwraca łańcuch znaków do wyświetlenia dla danego typu danych.
  """
  def jako_tekst(dana)
end

defimpl MozliwosciWyswietlania, for: Ksiazka do
  def jako_tekst(%Ksiazka{tytul: tytul, autor: autor, rok_wydania: rok}) do
    "Książka: \"#{tytul}\" autorstwa #{autor} (#{rok || "rok nieznany"})"
  end
end

defimpl MozliwosciWyswietlania, for: Pracownik do
  def jako_tekst(%Pracownik{imie: imie, nazwisko: nazwisko, stanowisko: stanowisko}) do
    "Pracownik: #{imie} #{nazwisko}, stanowisko: #{stanowisko}"
  end
end

# Korzystanie z własnego protokołu
IO.puts("Użycie własnego protokołu - książka: #{MozliwosciWyswietlania.jako_tekst(ksiazka)}")
IO.puts("Użycie własnego protokołu - pracownik: #{MozliwosciWyswietlania.jako_tekst(pracownik)}")

# ------ Porównywanie struktur ------
IO.puts("\n--- Porównywanie struktur ---")

osoba3 = %Osoba{imie: "Jan", nazwisko: "Kowalski", wiek: 30}
osoba4 = %Osoba{imie: "Jan", nazwisko: "Nowak", wiek: 30}

IO.puts("osoba2 == osoba3: #{osoba2 == osoba3}")  # Porównuje wszystkie pola
IO.puts("osoba2 == osoba4: #{osoba2 == osoba4}")

# ------ Struktury zagnieżdżone i rekurencyjne ------
IO.puts("\n--- Struktury zagnieżdżone i rekurencyjne ---")

defmodule Drzewo do
  @moduledoc """
  Moduł reprezentujący strukturę drzewa binarnego.
  """
  defstruct wartosc: nil, lewo: nil, prawo: nil

  @doc """
  Dodaje nową wartość do drzewa.
  """
  def dodaj(nil, wartosc), do: %Drzewo{wartosc: wartosc}
  def dodaj(%Drzewo{wartosc: w, lewo: lewo, prawo: prawo}, wartosc) when wartosc <= w do
    %Drzewo{wartosc: w, lewo: dodaj(lewo, wartosc), prawo: prawo}
  end
  def dodaj(%Drzewo{wartosc: w, lewo: lewo, prawo: prawo}, wartosc) do
    %Drzewo{wartosc: w, lewo: lewo, prawo: dodaj(prawo, wartosc)}
  end

  @doc """
  Wyświetla drzewo w porządku inorder.
  """
  def inorder(nil), do: []
  def inorder(%Drzewo{wartosc: w, lewo: lewo, prawo: prawo}) do
    inorder(lewo) ++ [w] ++ inorder(prawo)
  end
end

# Tworzenie drzewa
drzewo = nil
drzewo = Drzewo.dodaj(drzewo, 5)
drzewo = Drzewo.dodaj(drzewo, 3)
drzewo = Drzewo.dodaj(drzewo, 7)
drzewo = Drzewo.dodaj(drzewo, 1)
drzewo = Drzewo.dodaj(drzewo, 9)

IO.puts("Inorder drzewa: #{inspect(Drzewo.inorder(drzewo))}")

IO.puts("\nTo podsumowuje podstawowe operacje na strukturach w Elixir!")
