# Atrybuty modułów w Elixir

IO.puts("=== Atrybuty modułów w Elixir ===\n")

# ------ Podstawowe atrybuty modułów ------
IO.puts("--- Podstawowe atrybuty modułów ---")

defmodule Konfiguracja do
  @moduledoc """
  Moduł demonstracyjny pokazujący użycie atrybutów modułów.
  """

  # Atrybuty modułu - stałe
  @wersja "1.0.0"
  @autor "Jan Kowalski"
  @data_utworzenia ~D[2023-05-15]

  @doc """
  Zwraca informacje o wersji modułu.
  """
  def wersja, do: @wersja

  @doc """
  Zwraca informacje o autorze.
  """
  def autor, do: @autor

  @doc """
  Zwraca datę utworzenia modułu.
  """
  def data_utworzenia, do: @data_utworzenia

  @doc """
  Zwraca pełne informacje o module.
  """
  def info do
    "Konfiguracja v#{@wersja} utworzona przez #{@autor} dnia #{@data_utworzenia}"
  end
end

IO.puts("Wersja: #{Konfiguracja.wersja()}")
IO.puts("Autor: #{Konfiguracja.autor()}")
IO.puts("Data utworzenia: #{Konfiguracja.data_utworzenia()}")
IO.puts("Informacje: #{Konfiguracja.info()}")

# ------ Atrybuty jako metadane ------
IO.puts("\n--- Atrybuty jako metadane ---")

defmodule Produkt do
  @moduledoc """
  Moduł reprezentujący produkt w sklepie.
  """

  # Atrybuty używane jako metadane
  @kategorie [:elektronika, :agd, :meble, :zabawki]
  @stawki_vat %{standardowa: 0.23, obnizona: 0.08, super_obnizona: 0.05}
  @domyslna_waluta :PLN

  @doc """
  Zwraca listę dostępnych kategorii produktów.
  """
  def dostepne_kategorie, do: @kategorie

  @doc """
  Zwraca mapę stawek VAT.
  """
  def stawki_vat, do: @stawki_vat

  @doc """
  Oblicza cenę brutto na podstawie ceny netto i stawki VAT.
  """
  def cena_brutto(cena_netto, stawka \\ :standardowa) do
    vat = Map.get(@stawki_vat, stawka, @stawki_vat.standardowa)
    cena_netto * (1 + vat)
  end

  @doc """
  Formatuje cenę z domyślną walutą.
  """
  def formatuj_cene(cena, waluta \\ @domyslna_waluta) do
    "#{Float.round(cena, 2)} #{waluta}"
  end
end

IO.puts("Dostępne kategorie: #{inspect(Produkt.dostepne_kategorie())}")
IO.puts("Stawki VAT: #{inspect(Produkt.stawki_vat())}")

cena_brutto = Produkt.cena_brutto(100.0)
IO.puts("Cena brutto (standardowa stawka): #{Produkt.formatuj_cene(cena_brutto)}")

cena_brutto_obnizona = Produkt.cena_brutto(100.0, :obnizona)
IO.puts("Cena brutto (obniżona stawka): #{Produkt.formatuj_cene(cena_brutto_obnizona)}")

# ------ Atrybuty do rejestracji ------
IO.puts("\n--- Atrybuty do rejestracji ---")

defmodule Rejestr do
  @moduledoc """
  Moduł demonstracyjny pokazujący użycie atrybutów do rejestracji.
  """

  # Używamy atrybutu jako akumulatora
  Module.register_attribute(__MODULE__, :elementy, accumulate: true)

  @elementy "pierwszy"
  @elementy "drugi"
  @elementy "trzeci"

  def lista_elementow, do: @elementy
end

IO.puts("Zarejestrowane elementy: #{inspect(Rejestr.lista_elementow())}")

# ------ Atrybuty do dokumentacji ------
IO.puts("\n--- Atrybuty do dokumentacji ---")

defmodule Dokumentacja do
  @moduledoc """
  Moduł demonstracyjny pokazujący użycie atrybutów dokumentacji.

  Ten moduł zawiera przykłady użycia atrybutów `@moduledoc` i `@doc`.
  """

  @doc """
  Pozdrawia użytkownika.

  ## Parametry

  - `imie` - Imię osoby do pozdrowienia

  ## Przykłady

      iex> Dokumentacja.pozdrow("Jan")
      "Witaj, Jan!"

  """
  def pozdrow(imie) do
    "Witaj, #{imie}!"
  end

  @doc """
  Żegna użytkownika.

  ## Parametry

  - `imie` - Imię osoby do pożegnania

  ## Przykłady

      iex> Dokumentacja.pozegnaj("Jan")
      "Do widzenia, Jan!"

  """
  def pozegnaj(imie) do
    "Do widzenia, #{imie}!"
  end

  @doc false
  # Ta funkcja nie będzie widoczna w dokumentacji
  def funkcja_wewnetrzna do
    "Ta funkcja nie jest udokumentowana"
  end
end

# W normalnym użyciu dokumentacja jest dostępna przez:
# - `h Dokumentacja` w IEx (dokumentacja modułu)
# - `h Dokumentacja.pozdrow` w IEx (dokumentacja funkcji)

# ------ Typespecs - specyfikacje typów ------
IO.puts("\n--- Typespecs - specyfikacje typów ---")

defmodule Typespecs do
  @moduledoc """
  Moduł demonstracyjny pokazujący użycie specyfikacji typów.
  """

  @typedoc """
  Typ reprezentujący użytkownika.
  """
  @type uzytkownik :: %{
    id: integer,
    imie: String.t(),
    nazwisko: String.t(),
    wiek: non_neg_integer
  }

  @typedoc """
  Typ reprezentujący wynik operacji.
  """
  @type wynik :: {:ok, term} | {:error, String.t()}

  @doc """
  Tworzy nowego użytkownika.
  """
  @spec utworz_uzytkownika(String.t(), String.t(), non_neg_integer) :: uzytkownik
  def utworz_uzytkownika(imie, nazwisko, wiek) do
    %{
      id: :rand.uniform(1000),
      imie: imie,
      nazwisko: nazwisko,
      wiek: wiek
    }
  end

  @doc """
  Sprawdza czy użytkownik jest pełnoletni.
  """
  @spec pelnoletni?(uzytkownik) :: boolean
  def pelnoletni?(uzytkownik) do
    uzytkownik.wiek >= 18
  end

  @doc """
  Próbuje znaleźć użytkownika po ID.
  """
  @spec znajdz_uzytkownika(integer) :: wynik
  def znajdz_uzytkownika(id) when id > 0 do
    # Symulacja wyszukiwania
    if rem(id, 2) == 0 do
      {:ok, utworz_uzytkownika("Jan", "Kowalski", 30)}
    else
      {:error, "Nie znaleziono użytkownika o ID #{id}"}
    end
  end
end

uzytkownik = Typespecs.utworz_uzytkownika("Anna", "Nowak", 25)
IO.puts("Utworzono użytkownika: #{inspect(uzytkownik)}")
IO.puts("Czy użytkownik jest pełnoletni? #{Typespecs.pelnoletni?(uzytkownik)}")

case Typespecs.znajdz_uzytkownika(2) do
  {:ok, znaleziony} -> IO.puts("Znaleziono użytkownika: #{inspect(znaleziony)}")
  {:error, powod} -> IO.puts("Błąd: #{powod}")
end

case Typespecs.znajdz_uzytkownika(3) do
  {:ok, znaleziony} -> IO.puts("Znaleziono użytkownika: #{inspect(znaleziony)}")
  {:error, powod} -> IO.puts("Błąd: #{powod}")
end

# ------ Atrybuty do dostosowania zachowania kompilatora ------
IO.puts("\n--- Atrybuty do dostosowania zachowania kompilatora ---")

defmodule KompilatorDemo do
  # Wyłącza ostrzeżenia o nieużywanych zmiennych
  @compile {:no_warn_undefined, SomeModule}

  # Włącza śledzenie dla tego modułu
  # @compile :trace

  def demo do
    # Zmienna _nieuzywana nie wywoła ostrzeżenia
    _nieuzywana = "wartość"
    "Demo działania atrybutów kompilatora"
  end
end

IO.puts(KompilatorDemo.demo())

IO.puts("\nTo podsumowuje atrybuty modułów w Elixir!")
