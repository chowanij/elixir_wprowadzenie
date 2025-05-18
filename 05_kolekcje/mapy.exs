# Operacje na mapach w Elixir

IO.puts("=== Mapy w Elixir ===\n")

# ------ Tworzenie map ------
IO.puts("--- Tworzenie map ---")

# Pusta mapa
mapa_pusta = %{}
IO.puts("Pusta mapa: #{inspect(mapa_pusta)}")

# Mapa z elementami (kluczami są atomy)
osoba = %{imie: "Jan", nazwisko: "Kowalski", wiek: 30}
IO.puts("Osoba: #{inspect(osoba)}")

# Mapa z elementami (kluczami są różne typy)
mapa_mieszana = %{:atom_klucz => "wartość 1", "string_klucz" => :wartość2, 1 => "wartość 3"}
IO.puts("Mapa mieszana: #{inspect(mapa_mieszana)}")

# Mapa zagnieżdżona
pracownik = %{
  imie: "Anna",
  nazwisko: "Nowak",
  wiek: 28,
  adres: %{
    ulica: "Krakowska",
    miasto: "Warszawa",
    kod: "00-001"
  }
}
IO.puts("Pracownik (mapa zagnieżdżona): #{inspect(pracownik)}")

# ------ Dostęp do elementów ------
IO.puts("\n--- Dostęp do elementów mapy ---")

# Dostęp do elementu za pomocą .
imie = osoba.imie
IO.puts("Imię osoby (za pomocą .): #{imie}")

# Dostęp do elementu za pomocą [klucz]
nazwisko = osoba[:nazwisko]
IO.puts("Nazwisko osoby (za pomocą []): #{nazwisko}")

# Dostęp z wartością domyślną
nieistniejace_pole = Map.get(osoba, :zawod, "Brak danych")
IO.puts("Nieistniejące pole z wartością domyślną: #{nieistniejace_pole}")

# Dostęp do zagnieżdżonej mapy
miasto = pracownik.adres.miasto
IO.puts("Miasto pracownika: #{miasto}")

# Sprawdzenie czy klucz istnieje
IO.puts("Czy klucz :imie istnieje? #{Map.has_key?(osoba, :imie)}")
IO.puts("Czy klucz :zawod istnieje? #{Map.has_key?(osoba, :zawod)}")

# ------ Aktualizacja map ------
IO.puts("\n--- Aktualizacja map (niezmienność) ---")

# Aktualizacja pojedynczego klucza (składnia %)
osoba_zaktualizowana = %{osoba | wiek: 31}
IO.puts("Oryginalna osoba: #{inspect(osoba)}")
IO.puts("Osoba po aktualizacji wieku: #{inspect(osoba_zaktualizowana)}")

# Uwaga: Składnia %{mapa | klucz: wartość} działa tylko dla istniejących kluczy
# Dla dodania nowego klucza używamy Map.put/3

# Dodanie nowego klucza
osoba_z_nowym_polem = Map.put(osoba, :zawod, "Programista")
IO.puts("Osoba z nowym polem zawód: #{inspect(osoba_z_nowym_polem)}")

# Usunięcie klucza
osoba_bez_wieku = Map.delete(osoba, :wiek)
IO.puts("Osoba bez wieku: #{inspect(osoba_bez_wieku)}")

# Aktualizacja wielu kluczy
osoba_zaktualizowana_wiele = Map.merge(osoba, %{imie: "Adam", wiek: 35})
IO.puts("Osoba po aktualizacji wielu pól: #{inspect(osoba_zaktualizowana_wiele)}")

# ------ Przetwarzanie map ------
IO.puts("\n--- Przetwarzanie map ---")

# Pobranie wszystkich kluczy
klucze = Map.keys(osoba)
IO.puts("Klucze: #{inspect(klucze)}")

# Pobranie wszystkich wartości
wartosci = Map.values(osoba)
IO.puts("Wartości: #{inspect(wartosci)}")

# Pobranie wszystkich par klucz-wartość
pary = Map.to_list(osoba)
IO.puts("Pary klucz-wartość: #{inspect(pary)}")

# Mapowanie wartości (aktualizacja każdej wartości)
mapa_liczb = %{a: 1, b: 2, c: 3}
mapa_podwojona = Map.new(mapa_liczb, fn {k, v} -> {k, v * 2} end)
IO.puts("Mapa oryginalna: #{inspect(mapa_liczb)}")
IO.puts("Mapa z podwojonymi wartościami: #{inspect(mapa_podwojona)}")

# ------ Pattern matching z mapami ------
IO.puts("\n--- Pattern matching z mapami ---")

# Dopasowanie do wzorca
%{imie: imie_z_dopasowania, nazwisko: nazwisko_z_dopasowania} = osoba
IO.puts("Wyodrębnione imię: #{imie_z_dopasowania}, nazwisko: #{nazwisko_z_dopasowania}")

# Dopasowanie częściowe (nie trzeba podawać wszystkich kluczy)
%{imie: imie_pracownika} = pracownik
IO.puts("Imię pracownika: #{imie_pracownika}")

# Dopasowanie do zagnieżdżonej mapy
%{adres: %{miasto: miasto_pracownika}} = pracownik
IO.puts("Miasto pracownika: #{miasto_pracownika}")

# ------ Funkcje pomocnicze modułu Map ------
IO.puts("\n--- Funkcje pomocnicze modułu Map ---")

# Map.get_and_update - jednoczesne odczytanie i aktualizacja
{stary_wiek, zaktualizowana_osoba} = Map.get_and_update(osoba, :wiek, fn obecny_wiek -> {obecny_wiek, obecny_wiek + 1} end)
IO.puts("Stary wiek: #{stary_wiek}")
IO.puts("Zaktualizowana osoba: #{inspect(zaktualizowana_osoba)}")

# Map.fetch - bezpieczne pobieranie wartości
case Map.fetch(osoba, :imie) do
  {:ok, value} -> IO.puts("Znaleziono imię: #{value}")
  :error -> IO.puts("Nie znaleziono klucza")
end

case Map.fetch(osoba, :zawod) do
  {:ok, value} -> IO.puts("Znaleziono zawód: #{value}")
  :error -> IO.puts("Nie znaleziono klucza zawód")
end

# Map.update - aktualizacja z funkcją
zaktualizowana_osoba = Map.update(osoba, :wiek, 0, fn obecny_wiek -> obecny_wiek + 5 end)
IO.puts("Osoba po aktualizacji wieku o 5: #{inspect(zaktualizowana_osoba)}")

# ------ Konwersje ------
IO.puts("\n--- Konwersje ---")

# Tworzenie mapy z listy par
lista_par = [imie: "Piotr", nazwisko: "Wiśniewski", wiek: 40]
mapa_z_listy = Map.new(lista_par)
IO.puts("Mapa utworzona z listy: #{inspect(mapa_z_listy)}")

# Tworzenie mapy przez transformację listy
lista = ["a", "b", "c"]
mapa_z_transformacji = Map.new(lista, fn x -> {x, String.upcase(x)} end)
IO.puts("Mapa utworzona przez transformację listy: #{inspect(mapa_z_transformacji)}")

# Tworzenie struktury z mapy (konwersja dynamiczna)
defmodule User do
  defstruct [:imie, :nazwisko, :wiek]
end

user_struct = struct(User, osoba)
IO.puts("Struktura User z mapy: #{inspect(user_struct)}")

# ------ Wydajność map ------
IO.puts("\n--- Wydajność map ---")
IO.puts("• Dostęp do elementu: O(log n)")
IO.puts("• Aktualizacja/wstawianie/usuwanie: O(log n)")
IO.puts("• Mapy są zoptymalizowane dla małej liczby kluczy (< 32)")
IO.puts("• Dla małych map z kluczami będącymi atomami dostęp jest szybszy")

IO.puts("\nTo podsumowuje podstawowe operacje na mapach w Elixir!")
