# Operacje na stringach w Elixir

IO.puts("=== Operacje na stringach w Elixir ===\n")

# Podstawowe operacje
IO.puts("--- Podstawowe operacje ---")
tekst = "Elixir jest świetnym językiem programowania"

# Długość stringa
IO.puts("Długość tekstu: #{String.length(tekst)}")

# Konwersja wielkości liter
IO.puts("Duże litery: #{String.upcase(tekst)}")
IO.puts("Małe litery: #{String.downcase(tekst)}")
IO.puts("Z dużej litery: #{String.capitalize(tekst)}")

# Wyszukiwanie
IO.puts("\n--- Wyszukiwanie w tekście ---")
IO.puts("Czy zawiera 'świetnym': #{String.contains?(tekst, "świetnym")}")
IO.puts("Czy zaczyna się od 'Elixir': #{String.starts_with?(tekst, "Elixir")}")
IO.puts("Czy kończy się na 'programowania': #{String.ends_with?(tekst, "programowania")}")

# Pobieranie części tekstu
IO.puts("\n--- Części tekstu ---")
IO.puts("Pierwsze 6 znaków: #{String.slice(tekst, 0, 6)}")
IO.puts("Ostatnie 12 znaków: #{String.slice(tekst, -12, 12)}")
IO.puts("Od 7 do 14 znaku: #{String.slice(tekst, 7, 8)}")

# Dzielenie tekstu
IO.puts("\n--- Dzielenie tekstu ---")
slowa = String.split(tekst)
IO.puts("Słowa: #{inspect(slowa)}")
IO.puts("Liczba słów: #{length(slowa)}")

# Dzielenie z limitem
cztery_slowa = String.split(tekst, " ", parts: 4)
IO.puts("Pierwsze 4 części: #{inspect(cztery_slowa)}")

# Dzielenie po konkretnym znaku
po_literze_t = String.split(tekst, "t")
IO.puts("Podział po literze 't': #{inspect(po_literze_t)}")

# Łączenie tekstów
IO.puts("\n--- Łączenie tekstów ---")
lista_slow = ["Elixir", "jest", "produktywny", "i", "przyjemny"]
polaczone = Enum.join(lista_slow, " ")
IO.puts("Połączone słowa: #{polaczone}")

# Konkatenacja z operatorem <>
nowy_tekst = "Język " <> "Elixir " <> "jest " <> "funkcyjny"
IO.puts("Połączone stringi: #{nowy_tekst}")

# Interpolacja stringów
nazwa = "Elixir"
wersja = 1.14
IO.puts("#{nazwa} w wersji #{wersja} działa świetnie!")

# Usuwanie białych znaków
IO.puts("\n--- Usuwanie białych znaków ---")
tekst_z_bialymi = "   Tekst z białymi znakami   "
IO.puts("Oryginalny: '#{tekst_z_bialymi}'")
IO.puts("Po trimie: '#{String.trim(tekst_z_bialymi)}'")
IO.puts("Trim lewy: '#{String.trim_leading(tekst_z_bialymi)}'")
IO.puts("Trim prawy: '#{String.trim_trailing(tekst_z_bialymi)}'")

# Zamiana znaków
IO.puts("\n--- Zamiana znaków ---")
tekst_do_zamiany = "Elixir używa Erlang VM"
zamieniony = String.replace(tekst_do_zamiany, "Erlang VM", "BEAM")
IO.puts("Po zamianie: #{zamieniony}")

# Zamiana wszystkich wystąpień
tekst_z_powtorzeniami = "raz dwa raz trzy raz"
zamieniony2 = String.replace(tekst_z_powtorzeniami, "raz", "RAZ")
IO.puts("Po zamianie wszystkich: #{zamieniony2}")

# Formatowanie stringów
IO.puts("\n--- Formatowanie stringów ---")
imie = "Anna"
wiek = 30
sformatowany = :io_lib.format("Osoba: ~s, wiek: ~B lat", [imie, wiek])
IO.puts("Sformatowany tekst: #{sformatowany}")

# Praca z bajtami i kodowaniem
IO.puts("\n--- Bajty i kodowanie ---")
tekst_pl = "Zażółć gęślą jaźń"
IO.puts("Rozmiar w bajtach: #{byte_size(tekst_pl)}")
IO.puts("Długość (liczba znaków): #{String.length(tekst_pl)}")

# Iterowanie po znakach (graphemes)
IO.puts("\n--- Iterowanie po znakach ---")
znaki = String.graphemes("Elixir")
IO.puts("Znaki: #{inspect(znaki)}")

# Pierwsza litera
pierwszy_znak = String.first("Elixir")
IO.puts("Pierwszy znak: #{pierwszy_znak}")

# Ostatnia litera
ostatni_znak = String.last("Elixir")
IO.puts("Ostatni znak: #{ostatni_znak}")

# Odwrócenie tekstu
IO.puts("\n--- Odwrócenie tekstu ---")
odwrocony = String.reverse("Elixir")
IO.puts("Odwrócony: #{odwrocony}")

# Sigile (notacja dla stringów)
IO.puts("\n--- Sigile (special notacji) ---")
normalny_string = "String z \"cudzysłowami\""
IO.puts("Normalny string: #{normalny_string}")

# Sigil ~s (podobny do zwykłego stringa)
sigil_s = ~s(String z "cudzysłowami" bez konieczności escape'owania)
IO.puts("Sigil ~s: #{sigil_s}")

# Sigil ~S (bez interpolacji)
x = 10
sigil_S = ~S(Bez interpolacji: #{x})
IO.puts("Sigil ~S: #{sigil_S}")

# Heredoc - wieloliniowy string
wieloliniowy = """
To jest pierwszy wiersz.
To jest drugi wiersz.
A to jest trzeci wiersz.
"""
IO.puts("\nWieloliniowy string:")
IO.puts(wieloliniowy)
