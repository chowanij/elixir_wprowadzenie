# Operator pipe (|>) w Elixir

IO.puts("=== Operator pipe (|>) w Elixir ===\n")

# Operator pipe (|>) pozwala na przekazywanie wyniku jednej funkcji jako pierwszego argumentu do następnej funkcji
# To jeden z najważniejszych elementów składni Elixir, który czyni kod znacznie bardziej czytelnym

# Prosty przykład - przetwarzanie tekstu
IO.puts("--- Prosty przykład - przetwarzanie tekstu ---")

# Tradycyjny sposób zagnieżdżania funkcji (od wewnątrz na zewnątrz):
tekst = "  Elixir jest super językiem!  "
tekst_przetworzony = String.replace(String.downcase(String.trim(tekst)), "super", "świetnym")
IO.puts("Tradycyjny sposób: \"#{tekst_przetworzony}\"")

# Ten sam kod z operatorem pipe:
tekst_pipe = tekst
  |> String.trim()
  |> String.downcase()
  |> String.replace("super", "świetnym")
IO.puts("Z operatorem pipe: \"#{tekst_pipe}\"")

# Przykład przetwarzania listy
IO.puts("\n--- Przetwarzanie listy ---")

# Tradycyjny sposób (zagnieżdżone wywołania):
liczby = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
suma_kwadratow_parzystych = Enum.sum(Enum.map(Enum.filter(liczby, fn x -> rem(x, 2) == 0 end), fn x -> x * x end))
IO.puts("Suma kwadratów liczb parzystych (tradycyjnie): #{suma_kwadratow_parzystych}")

# Ten sam kod z operatorem pipe:
suma_pipe = liczby
  |> Enum.filter(fn x -> rem(x, 2) == 0 end) # Wybierz liczby parzyste
  |> Enum.map(fn x -> x * x end)             # Podnieś do kwadratu
  |> Enum.sum()                              # Zsumuj wyniki
IO.puts("Suma kwadratów liczb parzystych (z pipe): #{suma_pipe}")

# --------- Porównanie z JavaScript ---------
IO.puts("\n--- Porównanie z JavaScript ---")
IO.puts("W JavaScript (łańcuchowanie metod obiektowych):")
IO.puts("tekst.trim().toLowerCase().replace('super', 'świetnym')")

IO.puts("\nW JavaScript (Array methods):")
IO.puts("liczby.filter(x => x % 2 === 0).map(x => x * x).reduce((sum, x) => sum + x, 0)")

IO.puts("\nRóżnica jest taka, że operator pipe w Elixir działa z KAŻDĄ funkcją, nie tylko z metodami obiektów.")

# --------- Porównanie z Ruby ---------
IO.puts("\n--- Porównanie z Ruby ---")
IO.puts("W Ruby można użyć metody each_with_object lub inject/reduce:")
IO.puts("(1..10).select { |x| x.even? }.map { |x| x * x }.sum")

# --------- Zaawansowane użycie operatora pipe ---------
IO.puts("\n--- Zaawansowane użycie operatora pipe ---")

# Operator pipe przekazuje wynik jako PIERWSZY argument funkcji
# Przykład z funkcjami różnej arności:
def pomnoz(x, y), do: x * y
def dodaj(x, y), do: x + y
def podziel(x, y), do: x / y

wynik = 5
  |> pomnoz(10)    # przekazuje 5 jako pierwszy argument: pomnoz(5, 10)
  |> dodaj(2)      # przekazuje wynik 50 jako pierwszy argument: dodaj(50, 2)
  |> podziel(2)    # przekazuje wynik 52 jako pierwszy argument: podziel(52, 2)
IO.puts("Wynik obliczeń: 5 * 10 + 2 / 2 = #{wynik}")

# Zachowanie pozycji argumentu
IO.puts("\n--- Zachowanie pozycji argumentu ---")

# Gdy chcemy przekazać wynik jako argument na innej pozycji niż pierwsza:
# Możemy użyć funkcji anonimowej
liczba = 10
  |> (fn x -> :math.pow(2, x) end).()
  |> round()
IO.puts("2^10 = #{liczba}")

# Albo częściej używamy funkcji pomocniczej:
def do_potegi(podstawa, wykladnik), do: :math.pow(podstawa, wykladnik)

potega = 10
  |> (&do_potegi(2, &1)).()  # &1 odnosi się do wartości z pipe (10)
  |> round()
IO.puts("2^10 (z funkcją pomocniczą) = #{potega}")

# --------- Pipe i przetwarzanie danych ---------
IO.puts("\n--- Pipe i przetwarzanie danych ---")

dane = [
  %{imie: "Anna", wiek: 28, miasto: "Warszawa"},
  %{imie: "Tomasz", wiek: 35, miasto: "Kraków"},
  %{imie: "Ewa", wiek: 22, miasto: "Warszawa"},
  %{imie: "Piotr", wiek: 40, miasto: "Gdańsk"},
  %{imie: "Marek", wiek: 33, miasto: "Kraków"}
]

# Przetwarzanie danych z operator pipe - znajdowanie średniego wieku osób z Krakowa
sredni_wiek_krakow = dane
  |> Enum.filter(fn osoba -> osoba.miasto == "Kraków" end)
  |> Enum.map(fn osoba -> osoba.wiek end)
  |> (fn wiek_lista -> Enum.sum(wiek_lista) / length(wiek_lista) end).()

IO.puts("Średni wiek osób z Krakowa: #{sredni_wiek_krakow}")

# --------- Zalety operatora pipe ---------
IO.puts("\n--- Zalety operatora pipe ---")
IO.puts("1. Czytelniejszy kod, łatwiejszy w utrzymaniu")
IO.puts("2. Bardziej naturalny przepływ danych (od góry do dołu)")
IO.puts("3. Eliminacja zmiennych tymczasowych")
IO.puts("4. Łatwiejsze debugowanie (możemy przerwać łańcuch i sprawdzić stan)")
IO.puts("5. Sprzyja funkcyjnemu podejściu do rozwiązywania problemów")

# --------- Kiedy NIE używać operatora pipe ---------
IO.puts("\n--- Kiedy NIE używać operatora pipe ---")
IO.puts("1. Gdy transformacje nie tworzą naturalnego łańcucha")
IO.puts("2. Gdy wymagane jest przekazywanie wyniku do argumentu innego niż pierwszy")
IO.puts("3. Gdy kod jest bardziej czytelny bez pipe")
IO.puts("4. W bardzo prostych, pojedynczych wywołaniach funkcji")

# --------- Operator pipe i strumieniowanie (lazy evaluation) ---------
IO.puts("\n--- Pipe i strumieniowanie (lazy evaluation) ---")

# Enum jest gorliwy (eager) - przetwarza całą kolekcję za każdym krokiem
# Stream jest leniwy (lazy) - przetwarza element po elemencie przez cały pipeline

# Porównajmy wydajność na większej liście:
wieksze_liczby = Enum.to_list(1..1000)

# Używając Enum (eager):
IO.puts("Przetwarzając liczby od 1 do 1000:")

wieksze_liczby
  |> Enum.map(fn x -> x * 2 end)
  |> Enum.filter(fn x -> rem(x, 2) == 0 end)
  |> Enum.take(5)  # Bierzemy tylko 5 elementów
  |> IO.inspect(label: "Wynik z Enum")

# Używając Stream (lazy):
wieksze_liczby
  |> Stream.map(fn x -> x * 2 end)       # Nic się jeszcze nie dzieje
  |> Stream.filter(fn x -> rem(x, 2) == 0 end)  # Nadal nic
  |> Stream.take(5)                      # Określamy ile potrzebujemy
  |> Enum.to_list()                      # Dopiero tutaj wykonujemy obliczenia
  |> IO.inspect(label: "Wynik ze Stream")

# Stream jest bardziej wydajny, gdy:
# 1. Pracujesz z dużymi kolekcjami
# 2. Nie potrzebujesz przetwarzać całej kolekcji
# 3. Masz złożone transformacje

IO.puts("\nOperator pipe to jedna z najbardziej charakterystycznych i użytecznych cech Elixira!")
