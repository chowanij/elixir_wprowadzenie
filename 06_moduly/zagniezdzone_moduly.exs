# Zagnieżdżone moduły i przestrzenie nazw w Elixir

IO.puts("=== Zagnieżdżone moduły i przestrzenie nazw w Elixir ===\n")

# ------ Podstawowe zagnieżdżone moduły ------
IO.puts("--- Podstawowe zagnieżdżone moduły ---")

defmodule Firma do
  @moduledoc """
  Moduł główny reprezentujący firmę.
  """

  def nazwa do
    "Elixir Solutions Sp. z o.o."
  end

  defmodule Pracownik do
    @moduledoc """
    Moduł zagnieżdżony reprezentujący pracownika firmy.
    """

    def powitaj(imie) do
      "Witaj #{imie}, pracowniku firmy #{Firma.nazwa()}"
    end
  end

  defmodule Klient do
    @moduledoc """
    Moduł zagnieżdżony reprezentujący klienta firmy.
    """

    def powitaj(nazwa) do
      "Witamy firmę #{nazwa} jako klienta #{Firma.nazwa()}"
    end
  end
end

IO.puts("Nazwa firmy: #{Firma.nazwa()}")
IO.puts("Powitanie pracownika: #{Firma.Pracownik.powitaj("Jan")}")
IO.puts("Powitanie klienta: #{Firma.Klient.powitaj("ABC Corp")}")

# ------ Organizacja kodu za pomocą zagnieżdżonych modułów ------
IO.puts("\n--- Organizacja kodu za pomocą zagnieżdżonych modułów ---")

defmodule Aplikacja do
  @moduledoc """
  Główny moduł aplikacji.
  """

  defmodule Konfiguracja do
    @moduledoc """
    Moduł do zarządzania konfiguracją aplikacji.
    """

    @ustawienia %{
      port: 4000,
      host: "localhost",
      debug: true,
      max_connections: 100
    }

    def get(klucz) do
      Map.get(@ustawienia, klucz)
    end

    def all do
      @ustawienia
    end
  end

  defmodule Baza do
    @moduledoc """
    Moduł do zarządzania połączeniami z bazą danych.
    """

    def polacz do
      host = Aplikacja.Konfiguracja.get(:host)
      port = Aplikacja.Konfiguracja.get(:port)
      "Połączono z bazą danych na #{host}:#{port}"
    end

    defmodule Zapytanie do
      @moduledoc """
      Moduł do wykonywania zapytań do bazy danych.
      """

      def wykonaj(sql) do
        "Wykonano zapytanie: #{sql}"
      end
    end
  end

  defmodule UI do
    @moduledoc """
    Moduł do zarządzania interfejsem użytkownika.
    """

    defmodule Web do
      def renderuj do
        "Renderowanie interfejsu webowego"
      end
    end

    defmodule Mobile do
      def renderuj do
        "Renderowanie interfejsu mobilnego"
      end
    end
  end
end

IO.puts("Port z konfiguracji: #{Aplikacja.Konfiguracja.get(:port)}")
IO.puts(Aplikacja.Baza.polacz())
IO.puts(Aplikacja.Baza.Zapytanie.wykonaj("SELECT * FROM users"))
IO.puts(Aplikacja.UI.Web.renderuj())
IO.puts(Aplikacja.UI.Mobile.renderuj())

# ------ Dostęp do modułów nadrzędnych ------
IO.puts("\n--- Dostęp do modułów nadrzędnych ---")

defmodule Rodzic do
  @moduledoc """
  Moduł nadrzędny.
  """

  @wartosc "Wartość z modułu nadrzędnego"

  def metoda_rodzica do
    "Metoda z modułu nadrzędnego"
  end

  defmodule Dziecko do
    @moduledoc """
    Moduł potomny.
    """

    def pokaz_wartosc_rodzica do
      # Dostęp do atrybutu modułu nadrzędnego
      "Wartość z rodzica: #{Rodzic.metoda_rodzica()}"
    end

    def wywolaj_metode_rodzica do
      # Wywołanie metody z modułu nadrzędnego
      Rodzic.metoda_rodzica()
    end
  end
end

IO.puts(Rodzic.Dziecko.pokaz_wartosc_rodzica())
IO.puts(Rodzic.Dziecko.wywolaj_metode_rodzica())

# ------ Przestrzenie nazw i konwencje ------
IO.puts("\n--- Przestrzenie nazw i konwencje ---")

# Konwencja organizacji kodu w większych aplikacjach
defmodule MojaAplikacja do
  @moduledoc """
  Główna przestrzeń nazw aplikacji.
  """
end

defmodule MojaAplikacja.Konto do
  @moduledoc """
  Moduł do zarządzania kontami użytkowników.
  """

  def utworz(email, haslo) do
    "Utworzono konto dla #{email}"
  end
end

defmodule MojaAplikacja.Konto.Admin do
  @moduledoc """
  Moduł do zarządzania kontami administratorów.
  """

  def utworz(email, haslo) do
    "Utworzono konto administratora dla #{email}"
  end
end

defmodule MojaAplikacja.Produkt do
  @moduledoc """
  Moduł do zarządzania produktami.
  """

  def dodaj(nazwa, cena) do
    "Dodano produkt #{nazwa} za #{cena} zł"
  end
end

IO.puts(MojaAplikacja.Konto.utworz("user@example.com", "password123"))
IO.puts(MojaAplikacja.Konto.Admin.utworz("admin@example.com", "admin123"))
IO.puts(MojaAplikacja.Produkt.dodaj("Laptop", 3999))

# ------ Aliasy i importy dla zagnieżdżonych modułów ------
IO.puts("\n--- Aliasy i importy dla zagnieżdżonych modułów ---")

defmodule Aliasy do
  @moduledoc """
  Demonstracja użycia aliasów z zagnieżdżonymi modułami.
  """

  # Alias dla zagnieżdżonego modułu
  alias MojaAplikacja.Konto, as: UserAccount
  # Alias bez as: używa ostatniej części nazwy modułu
  alias MojaAplikacja.Produkt

  def demo do
    konto = UserAccount.utworz("demo@example.com", "demo123")
    produkt = Produkt.dodaj("Smartfon", 1999)
    "#{konto}\n#{produkt}"
  end
end

IO.puts(Aliasy.demo())

# ------ Zagnieżdżone moduły z protokołami ------
IO.puts("\n--- Zagnieżdżone moduły z protokołami ---")

defprotocol MojaAplikacja.Wyswietlanie do
  @moduledoc """
  Protokół do wyświetlania różnych typów obiektów.
  """
  def jako_tekst(dane)
end

defmodule MojaAplikacja.Uzytkownik do
  @moduledoc """
  Moduł reprezentujący użytkownika.
  """
  defstruct [:imie, :nazwisko, :email]
end

defmodule MojaAplikacja.Zamowienie do
  @moduledoc """
  Moduł reprezentujący zamówienie.
  """
  defstruct [:id, :produkty, :suma]
end

defimpl MojaAplikacja.Wyswietlanie, for: MojaAplikacja.Uzytkownik do
  def jako_tekst(uzytkownik) do
    "Użytkownik: #{uzytkownik.imie} #{uzytkownik.nazwisko} (#{uzytkownik.email})"
  end
end

defimpl MojaAplikacja.Wyswietlanie, for: MojaAplikacja.Zamowienie do
  def jako_tekst(zamowienie) do
    "Zamówienie ##{zamowienie.id}, suma: #{zamowienie.suma} zł, produkty: #{length(zamowienie.produkty)}"
  end
end

uzytkownik = %MojaAplikacja.Uzytkownik{imie: "Jan", nazwisko: "Kowalski", email: "jan@example.com"}
zamowienie = %MojaAplikacja.Zamowienie{id: 12345, produkty: ["Laptop", "Mysz", "Klawiatura"], suma: 4500}

IO.puts(MojaAplikacja.Wyswietlanie.jako_tekst(uzytkownik))
IO.puts(MojaAplikacja.Wyswietlanie.jako_tekst(zamowienie))

# ------ Dynamiczne nazwy modułów ------
IO.puts("\n--- Dynamiczne nazwy modułów ---")

defmodule MojaAplikacja.Dynamiczne do
  @moduledoc """
  Demonstracja dynamicznego tworzenia modułów.
  """

  def utworz_modul(nazwa) do
    # Konwersja nazwy na atom
    nazwa_modulu = String.to_atom("Elixir.MojaAplikacja.Dynamiczne.#{nazwa}")

    # Dynamiczne definiowanie modułu
    quoted = quote do
      defmodule unquote(nazwa_modulu) do
        def nazwa do
          unquote(nazwa)
        end

        def powitaj do
          "Witaj z dynamicznie utworzonego modułu #{nazwa()}!"
        end
      end
    end

    # Ewaluacja kodu
    Code.eval_quoted(quoted)

    # Zwrócenie nazwy modułu
    nazwa_modulu
  end
end

# Utworzenie dynamicznego modułu
modul = MojaAplikacja.Dynamiczne.utworz_modul("TestowyModul")
IO.puts("Utworzono moduł: #{modul}")

# Wywołanie metody z dynamicznie utworzonego modułu
if Code.ensure_loaded?(MojaAplikacja.Dynamiczne.TestowyModul) do
  IO.puts(MojaAplikacja.Dynamiczne.TestowyModul.powitaj())
else
  IO.puts("Moduł nie został załadowany")
end

IO.puts("\nTo podsumowuje zagnieżdżone moduły i przestrzenie nazw w Elixir!")
