# Aliasy, importy i dyrektywa use w Elixir

IO.puts("=== Aliasy, importy i dyrektywa use w Elixir ===\n")

# ------ Definiowanie modułów do przykładów ------

defmodule Narzedzia do
  @moduledoc """
  Moduł zawierający różne narzędzia pomocnicze.
  """

  def powitaj(imie) do
    "Witaj, #{imie}!"
  end

  def pozegnaj(imie) do
    "Do widzenia, #{imie}!"
  end

  def formatuj_date(data \\ Date.utc_today()) do
    "#{data.day}.#{data.month}.#{data.year}"
  end

  defmodule Tekst do
    @moduledoc """
    Narzędzia do operacji na tekście.
    """

    def wielkie_litery(tekst) do
      String.upcase(tekst)
    end

    def male_litery(tekst) do
      String.downcase(tekst)
    end

    def tytul(tekst) do
      tekst
      |> String.split()
      |> Enum.map(fn slowo -> String.capitalize(slowo) end)
      |> Enum.join(" ")
    end
  end

  defmodule Liczby do
    @moduledoc """
    Narzędzia do operacji na liczbach.
    """

    def suma(lista) do
      Enum.sum(lista)
    end

    def srednia(lista) when length(lista) > 0 do
      suma(lista) / length(lista)
    end

    def srednia(_), do: 0

    def formatuj(liczba, precyzja \\ 2) do
      :erlang.float_to_binary(liczba / 1, [decimals: precyzja])
    end
  end
end

defmodule Walidacja do
  @moduledoc """
  Moduł do walidacji danych.
  """

  def email?(email) do
    Regex.match?(~r/^[^\s]+@[^\s]+\.[^\s]+$/, email)
  end

  def numer_telefonu?(numer) do
    Regex.match?(~r/^[0-9]{9}$/, numer)
  end

  def kod_pocztowy?(kod) do
    Regex.match?(~r/^[0-9]{2}-[0-9]{3}$/, kod)
  end
end

# ------ Aliasy ------
IO.puts("--- Aliasy ---")

defmodule PrzykladAliasow do
  @moduledoc """
  Przykład użycia aliasów.
  """

  # Alias dla pojedynczego modułu
  alias Narzedzia.Tekst

  # Alias z własną nazwą
  alias Narzedzia.Liczby, as: Matematyka

  # Alias dla modułu nadrzędnego
  alias Narzedzia, as: Tools

  def demo do
    # Używamy aliasu Tekst zamiast Narzedzia.Tekst
    tekst_tytulowy = Tekst.tytul("przykład użycia aliasów w elixir")
    IO.puts("Tekst tytułowy: #{tekst_tytulowy}")

    # Używamy aliasu Matematyka zamiast Narzedzia.Liczby
    srednia = Matematyka.srednia([1, 2, 3, 4, 5])
    IO.puts("Średnia: #{srednia}")

    # Używamy aliasu Tools zamiast Narzedzia
    powitanie = Tools.powitaj("Jan")
    IO.puts("Powitanie: #{powitanie}")
  end
end

PrzykladAliasow.demo()

# ------ Importy ------
IO.puts("\n--- Importy ---")

defmodule PrzykladImportow do
  @moduledoc """
  Przykład użycia importów.
  """

  # Import wszystkich funkcji z modułu
  import Narzedzia.Tekst

  # Import wybranych funkcji z modułu
  import Narzedzia.Liczby, only: [suma: 1, srednia: 1]

  # Import wszystkich funkcji z modułu z wyjątkiem wybranych
  import Walidacja, except: [kod_pocztowy?: 1]

  def demo do
    # Używamy zaimportowanych funkcji bez prefiksu modułu
    tekst_duzy = wielkie_litery("to zostanie zamienione na wielkie litery")
    IO.puts("Wielkie litery: #{tekst_duzy}")

    tekst_maly = male_litery("TO ZOSTANIE ZAMIENIONE NA MAŁE LITERY")
    IO.puts("Małe litery: #{tekst_maly}")

    # Używamy zaimportowanych funkcji z Narzedzia.Liczby
    wynik_sumy = suma([10, 20, 30, 40, 50])
    IO.puts("Suma: #{wynik_sumy}")

    wynik_sredniej = srednia([10, 20, 30, 40, 50])
    IO.puts("Średnia: #{wynik_sredniej}")

    # Używamy zaimportowanych funkcji z Walidacja
    poprawny_email = email?("test@example.com")
    IO.puts("Czy email jest poprawny? #{poprawny_email}")

    poprawny_telefon = numer_telefonu?("123456789")
    IO.puts("Czy telefon jest poprawny? #{poprawny_telefon}")

    # Ta funkcja nie została zaimportowana, więc musimy użyć pełnej ścieżki
    poprawny_kod = Walidacja.kod_pocztowy?("12-345")
    IO.puts("Czy kod pocztowy jest poprawny? #{poprawny_kod}")
  end
end

PrzykladImportow.demo()

# ------ Importowanie operatorów ------
IO.puts("\n--- Importowanie operatorów ---")

defmodule Operatory do
  @moduledoc """
  Moduł definiujący własne operatory.
  """

  # Definiujemy operator dodawania wektorów
  def vec_add(a, b) when is_list(a) and is_list(b) and length(a) == length(b) do
    Enum.zip(a, b) |> Enum.map(fn {x, y} -> x + y end)
  end

  # Definiujemy operator mnożenia wektora przez skalar
  def vec_mul(a, b) when is_list(a) and is_number(b) do
    Enum.map(a, fn x -> x * b end)
  end
end

defmodule PrzykladOperatorow do
  @moduledoc """
  Przykład importowania operatorów.
  """

  # Importowanie funkcji operatorów
  import Operatory, only: [vec_add: 2, vec_mul: 2]

  def demo do
    wektor1 = [1, 2, 3]
    wektor2 = [4, 5, 6]

    # Użycie zaimportowanej funkcji dodawania wektorów
    suma_wektorow = vec_add(wektor1, wektor2)
    IO.puts("Suma wektorów [1, 2, 3] + [4, 5, 6] = #{inspect(suma_wektorow)}")

    # Użycie zaimportowanej funkcji mnożenia wektora przez skalar
    wektor_pomnozony = vec_mul(wektor1, 3)
    IO.puts("Wektor [1, 2, 3] * 3 = #{inspect(wektor_pomnozony)}")
  end
end

PrzykladOperatorow.demo()

# ------ Dyrektywa require ------
IO.puts("\n--- Dyrektywa require ---")

defmodule Makra do
  @moduledoc """
  Moduł definiujący makra.
  """

  defmacro debuguj(wyrazenie) do
    quote do
      IO.puts("Debugowanie: #{Macro.to_string(quote do: unquote(wyrazenie))}")
      wynik = unquote(wyrazenie)
      IO.puts("Wynik: #{inspect(wynik)}")
      wynik
    end
  end

  defmacro powtorz(ile, blok) do
    quote do
      Enum.each(1..unquote(ile), fn _ -> unquote(blok) end)
    end
  end
end

defmodule PrzykladRequire do
  @moduledoc """
  Przykład użycia dyrektywy require.
  """

  # Wymaganie modułu z makrami
  require Makra

  def demo do
    # Użycie makra debuguj
    Makra.debuguj(1 + 2 * 3)

    # Użycie makra powtorz
    Makra.powtorz(3, IO.puts("To zostanie wyświetlone 3 razy"))
  end
end

PrzykladRequire.demo()

# ------ Dyrektywa use ------
IO.puts("\n--- Dyrektywa use ---")

defmodule Rozszerzenie do
  @moduledoc """
  Moduł definiujący rozszerzenie dla innych modułów.
  """

  # Funkcja wywoływana przez dyrektywę use
  defmacro __using__(opcje) do
    powitanie = Keyword.get(opcje, :powitanie, "Witaj")

    quote do
      # Dodanie funkcji do modułu używającego rozszerzenia
      def pozdrow(imie) do
        "#{unquote(powitanie)}, #{imie}!"
      end

      def info do
        "Ten moduł używa rozszerzenia Rozszerzenie"
      end

      # Dodanie callbacku, który może być nadpisany
      def wlasne_powitanie(imie) do
        "Domyślne powitanie dla #{imie}"
      end

      # Definiowanie atrybutu modułu
      @rozszerzenie_uzyte true

      # Umożliwienie nadpisania funkcji
      defoverridable [wlasne_powitanie: 1]
    end
  end
end

defmodule PrzykladUse do
  @moduledoc """
  Przykład użycia dyrektywy use.
  """

  # Użycie rozszerzenia z domyślnymi opcjami
  use Rozszerzenie

  # Nadpisanie funkcji z rozszerzenia
  def wlasne_powitanie(imie) do
    "Specjalne powitanie dla #{imie}!"
  end
end

defmodule PrzykladUseZOpcjami do
  @moduledoc """
  Przykład użycia dyrektywy use z opcjami.
  """

  # Użycie rozszerzenia z własnymi opcjami
  use Rozszerzenie, powitanie: "Hola"
end

IO.puts(PrzykladUse.pozdrow("Jan"))
IO.puts(PrzykladUse.info())
IO.puts(PrzykladUse.wlasne_powitanie("Anna"))

IO.puts(PrzykladUseZOpcjami.pozdrow("Pedro"))
IO.puts(PrzykladUseZOpcjami.wlasne_powitanie("Maria"))

# ------ Praktyczny przykład use - Logger ------
IO.puts("\n--- Praktyczny przykład use - własny Logger ---")

defmodule MojLogger do
  @moduledoc """
  Prosty moduł loggera.
  """

  defmacro __using__(opcje) do
    poziom = Keyword.get(opcje, :poziom, :info)

    quote do
      # Importowanie funkcji pomocniczych
      import MojLogger, only: [log: 2]

      # Definiowanie funkcji loggera dla różnych poziomów
      def debug(wiadomosc), do: log(:debug, wiadomosc)
      def info(wiadomosc), do: log(:info, wiadomosc)
      def warning(wiadomosc), do: log(:warning, wiadomosc)
      def error(wiadomosc), do: log(:error, wiadomosc)

      # Ustawienie poziomu logowania
      @poziom_logowania unquote(poziom)
      def poziom_logowania, do: @poziom_logowania
    end
  end

  # Poziomy logowania jako wartości numeryczne
  @poziomy %{
    debug: 0,
    info: 1,
    warning: 2,
    error: 3
  }

  # Funkcja logująca
  def log(poziom, wiadomosc) do
    # Pobieramy nazwę modułu wywołującego
    {modul, _funkcja, _arnosc, _} = Process.info(self(), :current_stacktrace) |> elem(1) |> Enum.at(1)

    # Sprawdzamy, czy poziom logowania jest wystarczający
    if Map.get(@poziomy, poziom, 0) >= Map.get(@poziomy, apply(modul, :poziom_logowania, []), 0) do
      timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.to_string()
      IO.puts("[#{timestamp}] [#{poziom}] [#{modul}] #{wiadomosc}")
    end
  end
end

defmodule AplikacjaZLoggerem do
  @moduledoc """
  Przykładowa aplikacja używająca loggera.
  """

  # Używamy naszego loggera z poziomem info
  use MojLogger, poziom: :info

  def uruchom do
    debug("To nie zostanie wyświetlone, bo poziom to info")
    info("Aplikacja została uruchomiona")
    warning("To jest ostrzeżenie")
    error("Wystąpił błąd")
  end
end

defmodule AplikacjaZLoggeremDebug do
  @moduledoc """
  Przykładowa aplikacja używająca loggera z poziomem debug.
  """

  # Używamy naszego loggera z poziomem debug
  use MojLogger, poziom: :debug

  def uruchom do
    debug("To zostanie wyświetlone, bo poziom to debug")
    info("Aplikacja została uruchomiona")
  end
end

IO.puts("Logger z poziomem INFO:")
AplikacjaZLoggerem.uruchom()

IO.puts("\nLogger z poziomem DEBUG:")
AplikacjaZLoggeremDebug.uruchom()

IO.puts("\nTo podsumowuje aliasy, importy i dyrektywę use w Elixir!")
