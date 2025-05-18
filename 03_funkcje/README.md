# Funkcje w Elixir

Ten katalog zawiera materiały dotyczące funkcji w języku Elixir - jednego z najważniejszych aspektów tego języka funkcyjnego.

## Zawartość katalogu

W tym katalogu znajdziesz:

- `01_podstawy_funkcji.exs` - Definiowanie i używanie funkcji w Elixirze
- `02_funkcje_anonimowe.exs` - Funkcje anonimowe (lambdy)
- `03_pattern_matching.exs` - Dopasowanie wzorców w funkcjach
- `04_funkcje_rekurencyjne.exs` - Wykorzystanie rekurencji w Elixirze
- `05_operacje_na_tekstach/` - Katalog z materiałami o operacjach na stringach
  - `01_wyrazenia_regularne.exs` - Wykorzystanie wyrażeń regularnych
  - `02_operacje_na_stringach.exs` - Operacje na łańcuchach znaków
- `06_funkcje_wyzszego_rzedu.exs` - Funkcje przyjmujące inne funkcje jako argumenty
- `07_funkcyjne_wzorce/` - Katalog z materiałami o wzorcach funkcyjnych
  - `01_operator_pipe.exs` - Użycie operatora potoku (|>)
  - `02_porownanie_jezykow.exs` - Porównanie z innymi językami programowania

## Dlaczego funkcje są ważne w Elixirze?

Elixir jest językiem funkcyjnym, co oznacza, że funkcje są podstawowymi elementami konstrukcyjnymi programów:

- Funkcje są obywatelami pierwszej klasy (można je przekazywać, zwracać, przypisywać do zmiennych)
- Pattern matching w parametrach funkcji pozwala na eleganckie rozwiązania złożonych problemów
- Czyste funkcje (bez efektów ubocznych) ułatwiają testowanie i rozumienie kodu
- Kompozycja funkcji z użyciem operatora `|>` pozwala na tworzenie czytelnego kodu

## Kluczowe koncepcje

1. **Definiowanie funkcji**
   ```elixir
   def dodaj(a, b) do
     a + b
   end
   ```

2. **Funkcje prywatne**
   ```elixir
   defp funkcja_pomocnicza(x) do
     # implementacja
   end
   ```

3. **Funkcje anonimowe**
   ```elixir
   fn x -> x * 2 end
   ```

4. **Pattern matching w parametrach**
   ```elixir
   def procesuj([]), do: :pusta_lista
   def procesuj([glowa | ogon]), do: {:lista, glowa, ogon}
   ```

5. **Strażnicy (guards)**
   ```elixir
   def abs(x) when x >= 0, do: x
   def abs(x), do: -x
   ```

6. **Domyślne wartości parametrów**
   ```elixir
   def powitanie(imie, tekst \\ "Cześć") do
     "#{tekst}, #{imie}!"
   end
   ``` 