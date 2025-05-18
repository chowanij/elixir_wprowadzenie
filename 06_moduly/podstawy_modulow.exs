# Podstawy modułów w Elixir

IO.puts("=== Podstawy modułów w Elixir ===\n")

# ------ Definiowanie modułu ------
IO.puts("--- Definiowanie modułu ---")

defmodule Matematyka do
  @moduledoc """
  Moduł zawierający podstawowe operacje matematyczne.
  """

  @doc """
  Dodaje dwie liczby.

  ## Przykłady

      iex> Matematyka.dodaj(2, 3)
      5
  """
  def dodaj(a, b) do
    a + b
  end

  @doc """
  Odejmuje drugą liczbę od pierwszej.

  ## Przykłady

      iex> Matematyka.odejmij(5, 2)
      3
  """
  def odejmij(a, b) do
    a - b
  end

  @doc """
  Mnoży dwie liczby.

  ## Przykłady

      iex> Matematyka.pomnoz(2, 3)
      6
  """
  def pomnoz(a, b) do
    a * b
  end

  @doc """
  Dzieli pierwszą liczbę przez drugą.

  ## Przykłady

      iex> Matematyka.podziel(6, 2)
      3.0
  """
  def podziel(a, b) when b != 0 do
    a / b
  end

  def podziel(_, 0) do
    raise ArgumentError, "Nie można dzielić przez zero"
  end
end

# ------ Używanie modułu ------
IO.puts("\n--- Używanie modułu ---")

suma = Matematyka.dodaj(5, 3)
IO.puts("5 + 3 = #{suma}")

roznica = Matematyka.odejmij(10, 4)
IO.puts("10 - 4 = #{roznica}")

iloczyn = Matematyka.pomnoz(6, 7)
IO.puts("6 * 7 = #{iloczyn}")

iloraz = Matematyka.podziel(20, 4)
IO.puts("20 / 4 = #{iloraz}")

# ------ Funkcje prywatne ------
IO.puts("\n--- Funkcje prywatne ---")

defmodule Kalkulator do
  @moduledoc """
  Moduł kalkulatora z funkcjami prywatnymi.
  """

  @doc """
  Oblicza pole prostokąta.
  """
  def pole_prostokata(a, b) when a > 0 and b > 0 do
    a * b
  end

  @doc """
  Oblicza pole koła.
  """
  def pole_kola(r) when r > 0 do
    pi() * r * r
  end

  @doc """
  Oblicza obwód prostokąta.
  """
  def obwod_prostokata(a, b) when a > 0 and b > 0 do
    2 * (a + b)
  end

  @doc """
  Oblicza obwód koła.
  """
  def obwod_kola(r) when r > 0 do
    2 * pi() * r
  end

  # Funkcja prywatna - dostępna tylko wewnątrz modułu
  defp pi do
    3.14159
  end
end

pole = Kalkulator.pole_kola(5)
IO.puts("Pole koła o promieniu 5: #{pole}")

obwod = Kalkulator.obwod_kola(5)
IO.puts("Obwód koła o promieniu 5: #{obwod}")

# Próba dostępu do funkcji prywatnej spowoduje błąd
# Odkomentuj poniższą linię, aby zobaczyć błąd:
# pi_value = Kalkulator.pi()

# ------ Funkcje domyślne i opcjonalne argumenty ------
IO.puts("\n--- Funkcje domyślne i opcjonalne argumenty ---")

defmodule Powitania do
  @moduledoc """
  Moduł z funkcjami powitalnymi.
  """

  @doc """
  Wita użytkownika z opcjonalnym językiem.
  """
  def witaj(imie, jezyk \\ "polski") do
    case jezyk do
      "polski" -> "Cześć, #{imie}!"
      "angielski" -> "Hello, #{imie}!"
      "hiszpanski" -> "Hola, #{imie}!"
      _ -> "Witaj, #{imie}!"
    end
  end
end

IO.puts(Powitania.witaj("Jan"))
IO.puts(Powitania.witaj("John", "angielski"))
IO.puts(Powitania.witaj("Juan", "hiszpanski"))
IO.puts(Powitania.witaj("Hans", "niemiecki"))

# ------ Funkcje z wieloma klauzulami ------
IO.puts("\n--- Funkcje z wieloma klauzulami ---")

defmodule Silnia do
  @moduledoc """
  Moduł do obliczania silni.
  """

  @doc """
  Oblicza silnię liczby n.
  """
  def oblicz(0), do: 1
  def oblicz(1), do: 1
  def oblicz(n) when n > 0 and is_integer(n) do
    n * oblicz(n - 1)
  end
  def oblicz(_) do
    raise ArgumentError, "Argument musi być nieujemną liczbą całkowitą"
  end
end

IO.puts("Silnia z 0: #{Silnia.oblicz(0)}")
IO.puts("Silnia z 1: #{Silnia.oblicz(1)}")
IO.puts("Silnia z 5: #{Silnia.oblicz(5)}")

# ------ Funkcje z strażnikami (guards) ------
IO.puts("\n--- Funkcje ze strażnikami ---")

defmodule Sprawdzacz do
  @moduledoc """
  Moduł do sprawdzania typów i wartości.
  """

  @doc """
  Sprawdza typ i zwraca opis.
  """
  def sprawdz(wartość) when is_integer(wartość), do: "Liczba całkowita: #{wartość}"
  def sprawdz(wartość) when is_float(wartość), do: "Liczba zmiennoprzecinkowa: #{wartość}"
  def sprawdz(wartość) when is_atom(wartość), do: "Atom: #{wartość}"
  def sprawdz(wartość) when is_binary(wartość), do: "Ciąg znaków: #{wartość}"
  def sprawdz(wartość) when is_list(wartość), do: "Lista: #{inspect(wartość)}"
  def sprawdz(wartość) when is_map(wartość), do: "Mapa: #{inspect(wartość)}"
  def sprawdz(wartość) when is_tuple(wartość), do: "Krotka: #{inspect(wartość)}"
  def sprawdz(_), do: "Nieznany typ"

  @doc """
  Sprawdza zakres liczby.
  """
  def sprawdz_zakres(n) when n < 0, do: "Ujemna"
  def sprawdz_zakres(0), do: "Zero"
  def sprawdz_zakres(n) when n > 0 and n < 10, do: "Mała dodatnia (1-9)"
  def sprawdz_zakres(n) when n >= 10 and n < 100, do: "Średnia dodatnia (10-99)"
  def sprawdz_zakres(n) when n >= 100, do: "Duża dodatnia (100+)"
end

IO.puts(Sprawdzacz.sprawdz(42))
IO.puts(Sprawdzacz.sprawdz(3.14))
IO.puts(Sprawdzacz.sprawdz(:atom))
IO.puts(Sprawdzacz.sprawdz("tekst"))
IO.puts(Sprawdzacz.sprawdz([1, 2, 3]))
IO.puts(Sprawdzacz.sprawdz(%{a: 1, b: 2}))
IO.puts(Sprawdzacz.sprawdz({1, 2, 3}))

IO.puts(Sprawdzacz.sprawdz_zakres(-5))
IO.puts(Sprawdzacz.sprawdz_zakres(0))
IO.puts(Sprawdzacz.sprawdz_zakres(7))
IO.puts(Sprawdzacz.sprawdz_zakres(42))
IO.puts(Sprawdzacz.sprawdz_zakres(999))

# ------ Funkcje anonimowe ------
IO.puts("\n--- Funkcje anonimowe ---")

podwoj = fn x -> x * 2 end
IO.puts("Podwojenie 5: #{podwoj.(5)}")

powitaj = fn imie -> "Witaj, #{imie}!" end
IO.puts(powitaj.("Anna"))

# Funkcja anonimowa z wieloma argumentami
dodaj = fn a, b -> a + b end
IO.puts("2 + 3 = #{dodaj.(2, 3)}")

# Skrócona składnia dla funkcji anonimowych
lista = [1, 2, 3, 4, 5]
podwojona = Enum.map(lista, &(&1 * 2))
IO.puts("Podwojona lista: #{inspect(podwojona)}")

# Przekazywanie funkcji jako argumentów
defmodule Operacje do
  def wykonaj(a, b, funkcja) do
    funkcja.(a, b)
  end
end

wynik1 = Operacje.wykonaj(5, 3, &(&1 + &2))
IO.puts("5 + 3 = #{wynik1}")

wynik2 = Operacje.wykonaj(5, 3, &(&1 * &2))
IO.puts("5 * 3 = #{wynik2}")

# Referencje do funkcji
dodaj_ref = &Matematyka.dodaj/2
IO.puts("Referencja do dodaj: 7 + 8 = #{dodaj_ref.(7, 8)}")

IO.puts("\nTo podsumowuje podstawy modułów w Elixir!")
