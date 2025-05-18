# Podstawy funkcji w Elixir

IO.puts("=== Podstawy funkcji w Elixir ===\n")

# ------ Definiowanie funkcji w module ------
IO.puts("--- Definiowanie funkcji w module ---")

defmodule Matematyka do
  def dodaj(a, b) do
    a + b
  end

  def odejmij(a, b) do
    a - b
  end

  # Można używać skróconej składni dla krótkich funkcji
  def pomnoz(a, b), do: a * b

  def podziel(a, b) when b != 0, do: a / b
  def podziel(_, 0), do: {:error, "Nie można dzielić przez zero"}
end

IO.puts("2 + 3 = #{Matematyka.dodaj(2, 3)}")
IO.puts("5 - 2 = #{Matematyka.odejmij(5, 2)}")
IO.puts("4 * 6 = #{Matematyka.pomnoz(4, 6)}")
IO.puts("10 / 2 = #{Matematyka.podziel(10, 2)}")
IO.inspect(Matematyka.podziel(10, 0), label: "10 / 0")

# ------ Funkcje prywatne ------
IO.puts("\n--- Funkcje prywatne ---")

defmodule KalkulatorPodatkowy do
  def oblicz_podatek(kwota, stawka \\ 0.19) do
    podatek = oblicz_podstawe(kwota) * stawka
    zaokraglij(podatek)
  end

  # Funkcja prywatna - dostępna tylko wewnątrz modułu
  defp oblicz_podstawe(kwota) when kwota <= 0, do: 0
  defp oblicz_podstawe(kwota), do: kwota

  defp zaokraglij(kwota) do
    Float.round(kwota, 2)
  end
end

IO.puts("Podatek od 1000 zł: #{KalkulatorPodatkowy.oblicz_podatek(1000)}")
IO.puts("Podatek od 1000 zł stawką 23%: #{KalkulatorPodatkowy.oblicz_podatek(1000, 0.23)}")

# Próba wywołania funkcji prywatnej spowoduje błąd:
# KalkulatorPodatkowy.zaokraglij(123.456)  # UndefinedFunctionError

# ------ Doktryny funkcji (dokumentacja) ------
IO.puts("\n--- Dokumentacja funkcji ---")

defmodule Kalkulator do
  @moduledoc """
  Moduł zawierający podstawowe funkcje matematyczne.
  """

  @doc """
  Dodaje dwie liczby i zwraca ich sumę.

  ## Parametry
    - a: Pierwsza liczba
    - b: Druga liczba

  ## Przykłady
      iex> Kalkulator.dodaj(2, 3)
      5
  """
  def dodaj(a, b), do: a + b

  @doc """
  Odejmuje drugą liczbę od pierwszej.

  ## Parametry
    - a: Liczba od której odejmujemy
    - b: Liczba którą odejmujemy

  ## Przykłady
      iex> Kalkulator.odejmij(5, 2)
      3
  """
  def odejmij(a, b), do: a - b
end

# W interaktywnej konsoli możemy użyć pomocy:
# h Kalkulator.dodaj

# ------ Domyślne argumenty ------
IO.puts("\n--- Domyślne argumenty ---")

defmodule Powitanie do
  def witaj(imie, tekst \\ "Cześć") do
    "#{tekst}, #{imie}!"
  end

  # Funkcje z różną liczbą parametrów
  def przedstaw_sie(imie), do: "Jestem #{imie}"
  def przedstaw_sie(imie, nazwisko), do: "Jestem #{imie} #{nazwisko}"
end

IO.puts(Powitanie.witaj("Jan"))
IO.puts(Powitanie.witaj("Jan", "Dzień dobry"))
IO.puts(Powitanie.przedstaw_sie("Jan"))
IO.puts(Powitanie.przedstaw_sie("Jan", "Kowalski"))

# ------ Wieloklauzulowe funkcje ------
IO.puts("\n--- Wieloklauzulowe funkcje ---")

defmodule Silnia do
  def oblicz(0), do: 1
  def oblicz(n) when n > 0, do: n * oblicz(n - 1)
  # Nie obsługujemy liczb ujemnych
end

IO.puts("Silnia z 0: #{Silnia.oblicz(0)}")
IO.puts("Silnia z 5: #{Silnia.oblicz(5)}")

# ------ Funkcje zagnieżdżone ------
IO.puts("\n--- Funkcje zagnieżdżone ---")

defmodule Formatowanie do
  def sformatuj_imie(imie, nazwisko) do
    # Funkcja lokalna do formatowania imienia
    formatuj_czesc = fn string ->
      String.trim(string) |> String.capitalize()
    end

    "#{formatuj_czesc.(imie)} #{formatuj_czesc.(nazwisko)}"
  end
end

IO.puts(Formatowanie.sformatuj_imie("jan", "kowalski"))
IO.puts(Formatowanie.sformatuj_imie("ANNA", "NOWAK"))

# ------ Capturing funkcji ------
IO.puts("\n--- Capturing funkcji ---")

defmodule Operacje do
  def dodaj(a, b), do: a + b
  def odejmij(a, b), do: a - b
  def pomnoz(a, b), do: a * b
  def podziel(a, b), do: a / b
end

# Możemy "złapać" funkcję i przypisać do zmiennej
dodawanie = &Operacje.dodaj/2  # /2 oznacza arność funkcji (liczbę argumentów)
IO.puts("3 + 4 = #{dodawanie.(3, 4)}")

# Możemy przekazać funkcję jako argument
lista = [1, 2, 3, 4, 5]
podwojone = Enum.map(lista, &Operacje.pomnoz(&1, 2))
IO.puts("Podwojone elementy: #{inspect(podwojone)}")

# Skrócone odwołanie do funkcji dla prostych przypadków
potrojone = Enum.map(lista, &(&1 * 3))
IO.puts("Potrojone elementy: #{inspect(potrojone)}")

# ------ Zakończenie ------
IO.puts("\nTo podsumowuje podstawy funkcji w Elixir!")
