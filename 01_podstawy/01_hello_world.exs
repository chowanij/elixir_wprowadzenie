IO.puts("Hello, World!")

# To jest komentarz jednoliniowy

# Podstawowe operacje
IO.puts("Podstawowe operacje:")
IO.puts("1 + 2 = #{1 + 2}")
IO.puts("5 * 5 = #{5 * 5}")
IO.puts("10 / 2 = #{10 / 2}")

# Zmienne
imie = "Jan"
wiek = 30
IO.puts("\nZmienne:")
IO.puts("Imię: #{imie}")
IO.puts("Wiek: #{wiek}")

# Wieloliniowy string
IO.puts("\nWieloliniowy string:")
tekst = """
To jest przykład
wieloliniowego
tekstu w Elixir
"""
IO.puts(tekst)

# Uruchom ten skrypt poleceniem:
# elixir 01_hello_world.exs
