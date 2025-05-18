# Moduły w Elixir

Ten katalog zawiera przykłady dotyczące modułów w języku Elixir. Moduły są podstawowym sposobem organizacji kodu w Elixir, grupując funkcje i zapewniając przestrzenie nazw.

## Zawartość

- [**podstawy_modulow.exs**](podstawy_modulow.exs) - Podstawy definiowania i używania modułów
- [**atrybuty_modulow.exs**](atrybuty_modulow.exs) - Atrybuty modułów i dokumentacja
- [**zagniezdzone_moduly.exs**](zagniezdzone_moduly.exs) - Zagnieżdżone moduły i przestrzenie nazw
- [**aliasy_importy_use.exs**](aliasy_importy_use.exs) - Aliasy, importy i dyrektywa use
- [**delegowanie.exs**](delegowanie.exs) - Delegowanie funkcji
- [**behaviours.exs**](behaviours.exs) - Zachowania (behaviours) i implementacje
- [**protokoly.exs**](protokoly.exs) - Protokoły i polimorfizm

## Najważniejsze koncepcje

W tym rozdziale poznasz:

1. **Definiowanie modułów** - grupowanie powiązanych funkcji w logiczne jednostki
2. **Dokumentowanie kodu** - tworzenie dokumentacji modułów i funkcji
3. **Atrybuty modułów** - metadane i stałe na poziomie modułu
4. **Organizacja kodu** - strukturyzacja kodu poprzez zagnieżdżanie modułów
5. **Aliasy i importy** - upraszczanie dostępu do funkcji z innych modułów
6. **Zachowania (behaviours)** - definiowanie interfejsów dla modułów
7. **Protokoły** - polimorfizm w Elixir

## Dobre praktyki

- Jeden moduł na plik
- Nazwy modułów w CamelCase
- Nazwy plików w snake_case
- Grupowanie powiązanych funkcji w moduły
- Używanie atrybutów @moduledoc i @doc do dokumentowania kodu
- Definiowanie publicznego API modułu poprzez funkcje publiczne
- Używanie funkcji prywatnych do implementacji wewnętrznych szczegółów 