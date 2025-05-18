# Kolekcje w Elixir

Ten katalog zawiera przykłady dotyczące kolekcji danych w języku Elixir. Elixir oferuje bogaty zestaw struktur danych, które są niezmienne (immutable).

## Zawartość

- [**listy.exs**](listy.exs) - Operacje na listach
- [**mapy.exs**](mapy.exs) - Operacje na mapach
- [**struktury.exs**](struktury.exs) - Definiowanie i używanie struktur
- [**krotki.exs**](krotki.exs) - Praca z krotkami
- [**listy_skladane.exs**](listy_skladane.exs) - Listy składane (list comprehensions)
- [**enumerable.exs**](enumerable.exs) - Protokół Enumerable i moduł Enum
- [**kolekcje_zagniezdzone.exs**](kolekcje_zagniezdzone.exs) - Operacje na złożonych, zagnieżdżonych kolekcjach

## Najważniejsze funkcje

Elixir dostarcza wiele modułów do efektywnej pracy z kolekcjami:
- `Enum` - operacje na kolekcjach implementujących protokół Enumerable
- `List` - operacje specyficzne dla list
- `Map` - operacje na mapach
- `MapSet` - zbiory implementowane jako mapy
- `Stream` - leniwe wersje funkcji Enum

## Koncepcje

W tym rozdziale poznasz:
1. Metody tworzenia i manipulowania różnymi typami kolekcji
2. Efektywne użycie operacji funkcyjnych (map, reduce, filter)
3. Zrozumienie protokołu Enumerable
4. Wykorzystanie wzorców dopasowania (pattern matching) z kolekcjami
5. Tworzenie własnych struktur danych 