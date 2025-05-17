# Instrukcje sterujące w Elixir

IO.puts("=== Instrukcje sterujące w Elixir ===\n")

# Instrukcja if/else
wiek = 18

IO.puts("--- if/else ---")
if wiek >= 18 do
  IO.puts("Pełnoletni")
else
  IO.puts("Niepełnoletni")
end

# Instrukcja unless (odwrócone if)
IO.puts("\n--- unless ---")
unless wiek < 18 do
  IO.puts("Pełnoletni")
end

# Instrukcja case - pattern matching na wartości
IO.puts("\n--- case ---")
ocena = "B"

case ocena do
  "A" -> IO.puts("Bardzo dobry")
  "B" -> IO.puts("Dobry")
  "C" -> IO.puts("Dostateczny")
  "D" -> IO.puts("Dopuszczający")
  "F" -> IO.puts("Niedostateczny")
  _ -> IO.puts("Nieznana ocena") # domyślny przypadek (wildcard)
end

# Instrukcja cond - sekwencja warunków
IO.puts("\n--- cond ---")
punkty = 75

cond do
  punkty >= 90 -> IO.puts("Bardzo dobry")
  punkty >= 75 -> IO.puts("Dobry")
  punkty >= 60 -> IO.puts("Dostateczny")
  punkty >= 50 -> IO.puts("Dopuszczający")
  true -> IO.puts("Niedostateczny") # domyślny przypadek (zawsze prawdziwy)
end

# Instrukcja with - łańcuch pattern matching
IO.puts("\n--- with ---")
mapa = %{"imie" => "Jan", "wiek" => 30}

with {:ok, imie} <- Map.fetch(mapa, "imie"),
     {:ok, wiek} <- Map.fetch(mapa, "wiek") do
  IO.puts("Imię: #{imie}, Wiek: #{wiek}")
else
  :error -> IO.puts("Brak wymaganego klucza")
end

# Elixir nie ma tradycyjnych pętli for/while
# Zamiast tego używa rekurencji i funkcji wyższego rzędu

# Przykład użycia Enum.each (zamiast pętli for)
IO.puts("\n--- Enum.each (zamiast pętli for) ---")
lista = [1, 2, 3, 4, 5]

Enum.each(lista, fn x ->
  IO.puts("Element: #{x}")
end)

# Przykład użycia rekurencji (zamiast pętli while)
IO.puts("\n--- Rekurencja (zamiast pętli while) ---")

defmodule Petla do
  def odliczaj(0), do: IO.puts("Start!")
  def odliczaj(n) when n > 0 do
    IO.puts(n)
    odliczaj(n - 1)
  end
end

Petla.odliczaj(5)

# Operatory logiczne
IO.puts("\n--- Operatory logiczne ---")
a = true
b = false

IO.puts("a AND b: #{a and b}")
IO.puts("a OR b: #{a or b}")
IO.puts("NOT a: #{not a}")

# Operator trójargumentowy (nie istnieje w Elixir, ale można go zasymulować)
IO.puts("\n--- Symulacja operatora trójargumentowego ---")
wynik = if wiek >= 18, do: "pełnoletni", else: "niepełnoletni"
IO.puts("Status: #{wynik}")
