# Podstawowe typy danych w Elixir

IO.puts("=== Podstawowe typy danych w Elixir ===\n")

# Liczby całkowite (integers)
IO.puts("--- Liczby całkowite ---")
liczba_calkowita = 42
duza_liczba = 1_000_000  # podkreślniki dla czytelności
liczba_hex = 0xFF        # liczba szesnastkowa
liczba_oct = 0o755       # liczba ósemkowa
liczba_bin = 0b1010      # liczba binarna

IO.puts("Liczba całkowita: #{liczba_calkowita}")
IO.puts("Duża liczba: #{duza_liczba}")
IO.puts("Liczba szesnastkowa: #{liczba_hex}")
IO.puts("Liczba ósemkowa: #{liczba_oct}")
IO.puts("Liczba binarna: #{liczba_bin}")

# Liczby zmiennoprzecinkowe (floats)
IO.puts("\n--- Liczby zmiennoprzecinkowe ---")
liczba_float = 3.14159
liczba_naukowa = 1.0e10  # notacja naukowa

IO.puts("Liczba float: #{liczba_float}")
IO.puts("Notacja naukowa: #{liczba_naukowa}")

# Wartości logiczne (booleans)
IO.puts("\n--- Wartości logiczne ---")
prawda = true
falsz = false

IO.puts("Prawda: #{prawda}")
IO.puts("Fałsz: #{falsz}")
IO.puts("Negacja prawdy: #{not prawda}")

# Atomy (atoms) - stałe, których wartością jest ich nazwa
IO.puts("\n--- Atomy ---")
status = :ok
kolor = :czerwony
odpowiedz = :tak

IO.puts("Status: #{status}")
IO.puts("Kolor: #{kolor}")
IO.puts("Odpowiedź: #{odpowiedz}")

# Łańcuchy znaków (strings)
IO.puts("\n--- Łańcuchy znaków ---")
tekst = "Hello, Elixir!"
tekst_wieloliniowy = """
To jest przykład
tekstu wieloliniowego
w Elixir
"""

IO.puts("Tekst: #{tekst}")
IO.puts("Tekst wieloliniowy:\n#{tekst_wieloliniowy}")
IO.puts("Długość tekstu: #{String.length(tekst)}")
IO.puts("Tekst dużymi literami: #{String.upcase(tekst)}")
IO.puts("Łączenie tekstów: #{"Hello" <> ", " <> "World!"}")

# Listy znakowe (charlists)
IO.puts("\n--- Listy znakowe ---")
lista_znakow = 'Hello'  # pojedyncze cudzysłowy oznaczają listę znakową
IO.puts("Lista znakowa: #{lista_znakow}")
IO.puts("To jest lista liczb odpowiadających kodom ASCII: #{inspect(lista_znakow)}")

# Nil - odpowiednik null/None
IO.puts("\n--- Nil ---")
nic = nil
IO.puts("Wartość nil: #{inspect(nic)}")
IO.puts("Czy nil jest fałszem? #{nil == false}")  # false, nil i false to różne wartości

# Identyfikatory procesów (PIDs)
IO.puts("\n--- PID ---")
obecny_pid = self()
IO.puts("PID obecnego procesu: #{inspect(obecny_pid)}")

# Funkcje jako typy danych
IO.puts("\n--- Funkcje ---")
dodaj = fn a, b -> a + b end
wynik = dodaj.(5, 3)
IO.puts("Wynik funkcji dodaj: #{wynik}")

# Sprawdzanie typu
IO.puts("\n--- Sprawdzanie typu ---")
IO.puts("Typ liczby całkowitej: #{inspect(is_integer(42))}")
IO.puts("Typ łańcucha znaków: #{inspect(is_binary("tekst"))}")
IO.puts("Typ atomu: #{inspect(is_atom(:ok))}")
IO.puts("Typ funkcji: #{inspect(is_function(dodaj))}")
IO.puts("Typ wartości nil: #{inspect(is_nil(nil))}")
