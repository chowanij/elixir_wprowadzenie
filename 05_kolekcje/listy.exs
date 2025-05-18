# Operacje na listach w Elixir

IO.puts("=== Listy w Elixir ===\n")

# ------ Tworzenie list ------
IO.puts("--- Tworzenie list ---")

# Pusta lista
lista_pusta = []
IO.puts("Pusta lista: #{inspect(lista_pusta)}")

# Lista z elementami
lista_liczb = [1, 2, 3, 4, 5]
IO.puts("Lista liczb: #{inspect(lista_liczb)}")

# Lista z różnymi typami danych
lista_mieszana = [1, :atom, "tekst", 3.14, [1, 2]]
IO.puts("Lista mieszana: #{inspect(lista_mieszana)}")

# Tworzenie listy za pomocą operatora |
lista_polaczona = [0 | lista_liczb]
IO.puts("Lista połączona [0 | [1,2,3,4,5]]: #{inspect(lista_polaczona)}")

# ------ Podstawowe operacje ------
IO.puts("\n--- Podstawowe operacje ---")

# Długość listy
IO.puts("Długość listy liczb: #{length(lista_liczb)}")

# Dostęp do elementu (uwaga: operacja O(n))
pierwszy_element = List.first(lista_liczb)
IO.puts("Pierwszy element: #{pierwszy_element}")

ostatni_element = List.last(lista_liczb)
IO.puts("Ostatni element: #{ostatni_element}")

# Sprawdzanie czy element istnieje w liście
IO.puts("Czy 3 istnieje? #{3 in lista_liczb}")
IO.puts("Czy 10 istnieje? #{10 in lista_liczb}")

# ------ Łączenie list ------
IO.puts("\n--- Łączenie list ---")

# Operator ++
lista1 = [1, 2, 3]
lista2 = [4, 5, 6]
polaczona = lista1 ++ lista2
IO.puts("Lista1 ++ Lista2: #{inspect(polaczona)}")

# ------ Głowa i ogon listy ------
IO.puts("\n--- Głowa i ogon listy ---")

[head | tail] = lista_liczb
IO.puts("Głowa: #{head}")
IO.puts("Ogon: #{inspect(tail)}")

# Odczytanie wielu elementów
[a, b | rest] = lista_liczb
IO.puts("Pierwszy: #{a}, drugi: #{b}, reszta: #{inspect(rest)}")

# ------ Modyfikacja list ------
IO.puts("\n--- Modyfikacja list (niezmienność) ---")

# Listy są niezmienne - każda operacja tworzy nową listę
lista_oryginalna = [1, 2, 3]
lista_powiekszona = [0 | lista_oryginalna]
IO.puts("Oryginalna: #{inspect(lista_oryginalna)}")
IO.puts("Powiększona: #{inspect(lista_powiekszona)}")

# ------ Funkcje modułu List ------
IO.puts("\n--- Funkcje modułu List ---")

# Wstawienie elementu na określonej pozycji
lista_z_wstawieniem = List.insert_at(lista_liczb, 2, :nowy)
IO.puts("Wstawienie na pozycji 2: #{inspect(lista_z_wstawieniem)}")

# Usunięcie elementu
lista_z_usunieciem = List.delete(lista_liczb, 3)
IO.puts("Usunięcie wartości 3: #{inspect(lista_z_usunieciem)}")

# Usunięcie na pozycji
lista_z_usunieciem_pozycji = List.delete_at(lista_liczb, 1)
IO.puts("Usunięcie na pozycji 1: #{inspect(lista_z_usunieciem_pozycji)}")

# Zastąpienie elementu
lista_z_zastapienie = List.replace_at(lista_liczb, 0, 100)
IO.puts("Zastąpienie na pozycji 0: #{inspect(lista_z_zastapienie)}")

# Odwrócenie listy
lista_odwrocona = Enum.reverse(lista_liczb)
IO.puts("Odwrócona: #{inspect(lista_odwrocona)}")

# ------ Złożone operacje ------
IO.puts("\n--- Złożone operacje ---")

# Spłaszczanie list zagnieżdżonych
lista_zagniedzona = [1, [2, [3, 4]], 5]
lista_splaszczona = List.flatten(lista_zagniedzona)
IO.puts("Spłaszczenie zagnieżdżonej listy: #{inspect(lista_splaszczona)}")

# Dzielenie listy
{lewa, prawa} = Enum.split(lista_liczb, 3)
IO.puts("Podział listy: #{inspect(lewa)} i #{inspect(prawa)}")

# Przykład rekurencji na liście - sumowanie elementów
defmodule ListRecursion do
  def sum([]), do: 0
  def sum([head | tail]), do: head + sum(tail)
end

suma = ListRecursion.sum(lista_liczb)
IO.puts("\nSuma elementów listy (rekurencyjnie): #{suma}")

# ------ Wydajność operacji na listach ------
IO.puts("\n--- Wydajność operacji na listach ---")
IO.puts("• Szybki dostęp do pierwszego elementu (head): O(1)")
IO.puts("• Dostęp do elementu po indeksie (List.nth): O(n)")
IO.puts("• Dodawanie na początek (cons): O(1)")
IO.puts("• Dodawanie na koniec (append): O(n)")
IO.puts("• Usuwanie/wstawianie w środku: O(n)")

# ------ Konwersje ------
IO.puts("\n--- Konwersje ---")

# Lista na łańcuch znaków
lista_znakow = [65, 66, 67]
tekst = List.to_string(lista_znakow)
IO.puts("Lista znaków na string: #{tekst}")

# Łańcuch znaków na listę (charlista)
charlista = String.to_charlist("ABC")
IO.puts("String na charlistę: #{inspect(charlista)}")

IO.puts("\nTo podsumowuje podstawowe operacje na listach w Elixir!")
