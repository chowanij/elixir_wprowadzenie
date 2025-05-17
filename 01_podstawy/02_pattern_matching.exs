# Pattern matching - podstawy

IO.puts("=== Pattern Matching w Elixir ===\n")

# Podstawowe przypisanie
x = 1
IO.puts("x = #{x}")

# W Elixir operator = to operator dopasowania (match operator)
# Poniższe przypisze 1 do y, ponieważ x już ma wartość 1
1 = x
y = x
IO.puts("y = #{y}")

# To spowodowałoby błąd, ponieważ 2 != 1
# 2 = x

# Pattern matching z krotkami (tuples)
IO.puts("\n=== Pattern matching z krotkami ===")
osoba = {"Jan", "Kowalski", 30}
{imie, nazwisko, wiek} = osoba
IO.puts("Imię: #{imie}, Nazwisko: #{nazwisko}, Wiek: #{wiek}")

# Możemy dopasować tylko część wartości używając _
{imie, _, _} = osoba
IO.puts("Tylko imię: #{imie}")

# Pattern matching z listami
IO.puts("\n=== Pattern matching z listami ===")
lista = [1, 2, 3, 4, 5]
[pierwszy | reszta] = lista
IO.puts("Pierwszy element: #{pierwszy}")
IO.puts("Reszta listy: #{inspect(reszta)}")

# Pattern matching w argumentach funkcji
IO.puts("\n=== Pattern matching w funkcjach ===")

defmodule Matematyka do
  def factorial(0), do: 1
  def factorial(n) when n > 0, do: n * factorial(n - 1)

  def fibonacci(0), do: 0
  def fibonacci(1), do: 1
  def fibonacci(n) when n > 1, do: fibonacci(n - 1) + fibonacci(n - 2)
end

IO.puts("Silnia z 5: #{Matematyka.factorial(5)}")
IO.puts("Fibonacci(6): #{Matematyka.fibonacci(6)}")

# Pin operator (^) - używa istniejącej wartości zmiennej zamiast przypisania
IO.puts("\n=== Pin operator ===")
a = 1
IO.puts("a = #{a}")

# Normalne przypisanie - a otrzymuje nową wartość 2
a = 2
IO.puts("Po przypisaniu: a = #{a}")

# Użycie pin operatora - wymuszamy dopasowanie do istniejącej wartości a (2)
^a = 2
# To spowodowałoby błąd, ponieważ a ma wartość 2, a nie 3
# ^a = 3

IO.puts("Pattern matching to jedna z najważniejszych koncepcji w Elixir!")
