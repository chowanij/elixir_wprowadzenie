# Listy składane (list comprehensions) w Elixir

IO.puts("=== Listy składane w Elixir ===\n")

# ------ Podstawowa składnia list składanych ------
IO.puts("--- Podstawowa składnia ---")

# Proste listy składane
lista_kwadratow = for n <- 1..10, do: n * n
IO.puts("Lista kwadratów liczb 1-10: #{inspect(lista_kwadratow)}")

# Listy składane z filtrowaniem
parzyste_kwadraty = for n <- 1..10, rem(n, 2) == 0, do: n * n
IO.puts("Kwadraty liczb parzystych 1-10: #{inspect(parzyste_kwadraty)}")

# ------ Listy składane z wieloma źródłami ------
IO.puts("\n--- Listy składane z wieloma źródłami ---")

# Dwa generatory - iloczyn kartezjański
iloczyn_kartezjanski = for x <- 1..3, y <- 1..3, do: {x, y}
IO.puts("Iloczyn kartezjański 1..3 × 1..3: #{inspect(iloczyn_kartezjanski)}")

# Zagnieżdżone generatory
zagniezdzone = for x <- 1..3, y <- 1..x, do: {x, y}
IO.puts("Zagnieżdżone generatory (y ≤ x): #{inspect(zagniezdzone)}")

# ------ Listy składane z filtrowaniem ------
IO.puts("\n--- Listy składane z filtrowaniem ---")

# Filtrowanie po wartościach
lista_z_filtrem = for x <- 1..10, x > 5, rem(x, 2) == 0, do: x
IO.puts("Parzyste liczby większe od 5 z zakresu 1-10: #{inspect(lista_z_filtrem)}")

# Filtrowanie po pozycji w liście źródłowej
lista = [:a, 1, :b, 2, :c, 3, :d, 4]
tylko_atomy = for elem <- lista, is_atom(elem), do: elem
IO.puts("Tylko atomy z listy: #{inspect(tylko_atomy)}")

tylko_liczby = for elem <- lista, is_integer(elem), do: elem * 10
IO.puts("Tylko liczby z listy (pomnożone przez 10): #{inspect(tylko_liczby)}")

# ------ Transformacje w listach składanych ------
IO.puts("\n--- Transformacje w listach składanych ---")

# Proste transformacje
lista_liczb = [1, 2, 3, 4, 5]
podwojone = for x <- lista_liczb, do: x * 2
IO.puts("Podwojone liczby: #{inspect(podwojone)}")

# Transformacja stringów
slowa = ["Elixir", "jest", "super"]
duze_litery = for slowo <- slowa, do: String.upcase(slowo)
IO.puts("Słowa dużymi literami: #{inspect(duze_litery)}")

# Transformacja map
osoby = [
  %{imie: "Jan", wiek: 30},
  %{imie: "Anna", wiek: 28},
  %{imie: "Piotr", wiek: 35}
]

imiona = for osoba <- osoby, do: osoba.imie
IO.puts("Tylko imiona: #{inspect(imiona)}")

pelnoletni = for %{imie: imie, wiek: wiek} <- osoby, wiek >= 18, do: imie
IO.puts("Imiona pełnoletnich: #{inspect(pelnoletni)}")

# ------ Klauzula :into ------
IO.puts("\n--- Klauzula :into ---")

# Przekształcenie wyników do mapy
mapa_kwadratow = for n <- 1..5, into: %{}, do: {n, n * n}
IO.puts("Mapa kwadratów: #{inspect(mapa_kwadratow)}")

# Przekształcenie do łańcucha znaków
tekst = for n <- 1..5, into: "", do: "#{n}"
IO.puts("Liczby jako tekst: #{inspect(tekst)}")

# Przekształcenie do MapSet
liczby = [1, 2, 2, 3, 3, 3, 4, 5, 5]
uniq = for n <- liczby, into: MapSet.new(), do: n
IO.puts("Unikalne liczby jako MapSet: #{inspect(uniq)}")

# ------ Listy składane w praktycznych przykładach ------
IO.puts("\n--- Praktyczne przykłady ---")

# Spłaszczanie listy list
lista_list = [[1, 2], [3, 4], [5, 6]]
splaszczona = for podlista <- lista_list, n <- podlista, do: n
IO.puts("Spłaszczona lista list: #{inspect(splaszczona)}")

# Przekształcanie danych JSON-podobnych (mapy zagnieżdżone)
json_data = [
  %{id: 1, dane: %{nazwa: "Produkt A", cena: 100}},
  %{id: 2, dane: %{nazwa: "Produkt B", cena: 200}},
  %{id: 3, dane: %{nazwa: "Produkt C", cena: 300}}
]

uproszczone_dane = for %{id: id, dane: %{nazwa: nazwa, cena: cena}} <- json_data, do: "#{id}: #{nazwa} (#{cena} zł)"
IO.puts("Uproszczone dane produktów:")
Enum.each(uproszczone_dane, &IO.puts("  #{&1}"))

# Parsowanie danych z pliku tekstowego (symulacja)
linie = [
  "id:1;Jan;Kowalski;30",
  "id:2;Anna;Nowak;28",
  "id:3;Piotr;Wiśniewski;35"
]

sparsowane = for linia <- linie do
  [id, imie, nazwisko, wiek] = String.split(linia, [";", ":"])
  %{id: String.to_integer(List.last(id)), imie: imie, nazwisko: nazwisko, wiek: String.to_integer(wiek)}
end

IO.puts("\nSparsowane dane osobowe:")
Enum.each(sparsowane, fn osoba ->
  IO.puts("  ID: #{osoba.id}, #{osoba.imie} #{osoba.nazwisko}, #{osoba.wiek} lat")
end)

# ------ Wielopoziomowe listy składane (zagnieżdżone generatory) ------
IO.puts("\n--- Zagnieżdżone generatory ---")

# Podlisty liczb
liczby_zagniezdzone = for x <- 1..3, y <- 1..x do
  for z <- 1..y, do: {x, y, z}
end

IO.puts("Zagnieżdżone listy składane:")
Enum.with_index(liczby_zagniezdzone) |> Enum.each(fn {lista, indeks} ->
  IO.puts("  Lista #{indeks + 1}: #{inspect(lista)}")
end)

# Spłaszczenie wyniku
liczby_splaszczone = for x <- 1..3, y <- 1..x, z <- 1..y, do: {x, y, z}
IO.puts("Spłaszczona wersja: #{inspect(liczby_splaszczone)}")

# ------ Wydajność list składanych ------
IO.puts("\n--- Wydajność list składanych ---")
IO.puts("• Listy składane są często bardziej czytelne niż Enum.map + Enum.filter")
IO.puts("• Wydajność jest porównywalna z połączeniem Enum.map i Enum.filter")
IO.puts("• Używaj list składanych dla prostych transformacji i filtrów")
IO.puts("• Dla złożonej logiki biznesowej preferuj moduł Enum lub Stream")

# ------ Porównanie z mapowaniem i filtrowaniem ------
IO.puts("\n--- Porównanie z Enum.map + Enum.filter ---")

# Za pomocą list składanych
wynik1 = for n <- 1..10, rem(n, 2) == 0, do: n * n
IO.puts("Za pomocą list składanych: #{inspect(wynik1)}")

# Za pomocą Enum.map i Enum.filter
wynik2 = 1..10 |> Enum.filter(fn n -> rem(n, 2) == 0 end) |> Enum.map(fn n -> n * n end)
IO.puts("Za pomocą Enum.map/filter: #{inspect(wynik2)}")

IO.puts("\nTo podsumowuje podstawowe operacje na listach składanych w Elixir!")
