# Wprowadzenie do Elixir

Ten projekt służy jako wprowadzenie do języka programowania Elixir. Struktura folderów pozwala na stopniowe poznawanie kluczowych koncepcji języka.

## Struktura projektu

- `01_podstawy` - Pierwsze kroki z Elixir, instalacja, uruchamianie kodu
- `02_typy_danych` - Typy danych w Elixir (liczby, łańcuchy znaków, atomy, itd.)
- `03_funkcje` - Definiowanie i używanie funkcji
- `03_5_operacje_na_tekstach` - Operacje na stringach i wyrażenia regularne
- `03_7_funkcyjne_wzorce` - Operator pipe i porównanie z innymi językami
- `04_instrukcje_sterujace` - Instrukcje warunkowe, przepływ sterowania
- `05_kolekcje` - Listy, mapy, struktury, krotki
- `06_moduly` - Organizacja kodu w modułach
- `07_procesy` - Współbieżność i procesy w Elixir
- `08_obsluga_bledow` - Obsługa błędów i wyjątków
- `09_mix_projekty` - Tworzenie pełnych projektów przy użyciu narzędzia Mix
- `10_praktyczne_zadania` - Praktyczne przykłady wykorzystania Elixir w rzeczywistych projektach

## Kluczowe koncepcje w Elixir

- **Pattern matching (rozpoznawanie wzorców)** - Fundamentalna koncepcja w Elixir, pozwala na dopasowywanie wartości do wzorców i wyodrębnianie części danych
- **Niezmienność danych (immutability)** - Dane w Elixir są niezmienne, co eliminuje wiele błędów związanych z mutacją stanu
- **Funkcyjne programowanie** - Nacisk na czystość funkcji i unikanie efektów ubocznych
- **Kompozycja operatorów (pipe operator)** - Operator `|>` pozwalający na eleganckie łączenie wielu funkcji
- **Rekurencja** - Wielokrotne wywołanie funkcji zamiast klasycznych pętli
- **Strażnicy (guards)** - Dodatkowe warunki w definicjach funkcji
- **Protokoły** - Mechanizm polimorfizmu w Elixir
- **Makra** - Metaprogramowanie pozwalające na rozszerzanie języka

## Środowiska programistyczne dla Elixir

Wybór odpowiedniego edytora kodu lub IDE może znacząco wpłynąć na efektywność pracy z Elixirem:

1. **VSCode** - najpopularniejsze środowisko z doskonałym wsparciem dla Elixira:
   - Zainstaluj rozszerzenie "ElixirLS: Elixir Language Server"
   - Zapewnia podpowiedzi kodu, formatowanie, nawigację i diagnostykę
   - Dodatkowe użyteczne rozszerzenia: "Elixir Formatter", "Elixir Test Explorer"

2. **IntelliJ IDEA** z pluginem "Elixir":
   - Kompleksowe wsparcie dla Elixira w płatnym środowisku
   - Dobra integracja z narzędziami Mix

3. **Emacs** z trybem "alchemist.el":
   - Zaawansowana konfigurowalność
   - Idealny dla osób przyzwyczajonych do Emacsa

4. **Vim/Neovim** z pluginem "vim-elixir":
   - Szybka edycja kodu dla doświadczonych użytkowników Vim
   - Możliwość rozszerzenia funkcjonalności przez dodatkowe pluginy

5. **Cursor** - nowe IDE bazujące na VSCode z dodatkowymi funkcjami AI:
   - Podobne wsparcie dla Elixira jak VSCode
   - Dodatkowe funkcje AI asystenta

## Konwencje i dobre praktyki w Elixir

### Konwencje nazewnictwa

1. **Nazwy zmiennych i funkcji**:
   - Używaj snake_case: `moja_zmienna`, `oblicz_wartosc`
   - Nazwy powinny być opisowe i jasno wskazywać przeznaczenie

2. **Nazwy modułów**:
   - Używaj CamelCase: `MojModul`, `ParserXML`
   - Moduły zagnieżdżone używają kropki: `MojModul.Pomocniczy`

3. **Atomy i klucze**:
   - Używaj snake_case: `:moj_atom`, `:status_ok`
   - Dla kluczy w mapach preferuj atomy gdy to możliwe: `%{imie: "Jan", nazwisko: "Kowalski"}`

4. **Stałe**:
   - Używaj SCREAMING_SNAKE_CASE: `@MAX_LIMIT`, `@DEFAULT_TIMEOUT`

### Dobre praktyki

1. **Używaj Pattern Matching zamiast warunkowych ifów**:
   ```elixir
   # Zamiast:
   def process(data) do
     if is_list(data) do
       # kod dla listy
     else
       # kod dla nie-listy
     end
   end

   # Lepiej:
   def process(data) when is_list(data) do
     # kod dla listy
   end
   def process(data) do
     # kod dla nie-listy
   end
   ```

2. **Używaj operatora pipe (|>) dla zwiększenia czytelności**:
   ```elixir
   # Zamiast:
   result = step3(step2(step1(data)))

   # Lepiej:
   result = data |> step1() |> step2() |> step3()
   ```

3. **Dokumentuj swój kod**:
   - Używaj komentarzy dokumentacyjnych `@moduledoc` i `@doc`
   - Dodawaj przykłady kodu za pomocą `@example`

4. **Testuj swój kod**:
   - Pisz testy dla swoich funkcji używając ExUnit
   - Dąż do wysokiego pokrycia testów

5. **Unikaj zmienności stanu**:
   - Pamiętaj, że dane w Elixir są niezmienne
   - Używaj transformacji danych zamiast modyfikacji "na miejscu"
   - Dla współdzielonego stanu używaj procesów (GenServer)

6. **Obsługa błędów**:
   - Używaj `{:ok, result}` i `{:error, reason}` dla funkcji, które mogą się nie powieść
   - Używaj `with` dla eleganckich łańcuchów operacji

7. **Organizacja kodu**:
   - Jeden moduł w pliku
   - Grupuj funkcje logicznie wewnątrz modułu
   - Korzystaj z prywatnych funkcji pomocniczych

8. **Zachowaj czytelność kodu**:
   - Używaj formatera kodu (`mix format`)
   - Nie pisz zbyt długich funkcji
   - Przestrzegaj konwencji stylu kodu Elixir

## Praktyczne zadania

W katalogu `10_praktyczne_zadania` znajdziesz przykłady zastosowania Elixira do rozwiązywania praktycznych problemów:

1. Operacje na plikach i folderach
2. Przetwarzanie danych strukturalnych (JSON, YAML, CSV)
3. Generowanie drzewa katalogów z pliku JSON
4. Tworzenie prostego REST API
5. I inne...

## Jak uruchamiać kod w Elixir

1. **Interaktywna konsola IEx**:
   ```bash
   iex
   ```
   W konsoli możesz pisać i natychmiast wykonywać kod Elixir:
   ```elixir
   iex> 1 + 1
   2
   iex> "Hello" <> " World"
   "Hello World"
   ```

2. **Uruchamianie skryptów**:
   - Zapisz kod w pliku z rozszerzeniem `.exs` (skrypt Elixir) lub `.ex` (kompilowany moduł)
   - Uruchom skrypt poleceniem:
     ```bash
     elixir nazwa_pliku.exs
     ```

3. **Kompilacja kodu**:
   ```bash
   elixirc nazwa_pliku.ex
   ```
   Tworzy to skompilowane pliki `.beam`, które mogą być uruchomione w maszynie wirtualnej BEAM

4. **Uruchamianie testów**:
   ```bash
   mix test
   ```

5. **Uruchamianie projektu Mix**:
   ```bash
   mix run
   ```
   lub z interaktywną konsolą:
   ```bash
   iex -S mix
   ```

## Rekomendowane zasoby

- [Oficjalna dokumentacja Elixir](https://elixir-lang.org/docs.html)
- [Elixir School](https://elixirschool.com/pl/) - dostępne również po polsku
- [Programming Elixir](https://pragprog.com/titles/elixir16/programming-elixir-1-6/) - książka Dave'a Thomasa
- [ElixirForum](https://elixirforum.com/) - społeczność Elixir, gdzie można zadawać pytania
- [Elixir Radar](https://elixir-radar.com/) - newsletter o nowościach w ekosystemie Elixir
- [Awesome Elixir](https://github.com/h4cc/awesome-elixir) - lista bibliotek i zasobów dla Elixira
