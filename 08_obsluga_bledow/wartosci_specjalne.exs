# Specjalne wartości zwracane w przypadku błędów

IO.puts("=== Specjalne wartości zwracane w przypadku błędów ===\n")

# W Elixir zamiast zgłaszania wyjątków często używa się specjalnych
# wartości zwrotnych do sygnalizowania błędów lub niepowodzeń.

# ------ Użycie tupli {:ok, value} i {:error, reason} ------
IO.puts("--- Użycie tupli {:ok, value} i {:error, reason} ---")

# Wiele funkcji w Elixir zwraca tuple {:ok, wynik} dla sukcesu
# lub {:error, powód} dla niepowodzenia

defmodule OperacjePlikow do
  def otworz_plik(sciezka) do
    case File.read(sciezka) do
      {:ok, zawartosc} -> {:ok, zawartosc}
      {:error, powod} -> {:error, "Błąd podczas czytania pliku: #{powod}"}
    end
  end
end

przypadek1 = OperacjePlikow.otworz_plik("nieistniejacy_plik.txt")
IO.puts("Wynik dla nieistniejącego pliku: #{inspect(przypadek1)}")

# Tworzenie tymczasowego pliku do testowania
{:ok, plik} = File.open("test_file.txt", [:write])
IO.write(plik, "Testowa zawartość pliku")
File.close(plik)

przypadek2 = OperacjePlikow.otworz_plik("test_file.txt")
IO.puts("Wynik dla istniejącego pliku: #{inspect(przypadek2)}")

# Usunięcie tymczasowego pliku
File.rm("test_file.txt")

# ------ Obsługa tupli błędów przez pattern matching ------
IO.puts("\n--- Obsługa tupli błędów przez pattern matching ---")

defmodule ObslugaBledow do
  def przetworz_plik(sciezka) do
    case OperacjePlikow.otworz_plik(sciezka) do
      {:ok, zawartosc} ->
        {:ok, "Przetworzona zawartość: #{String.length(zawartosc)} znaków"}
      {:error, powod} ->
        {:error, powod}
    end
  end
end

case ObslugaBledow.przetworz_plik("nieistniejacy_plik.txt") do
  {:ok, wynik} -> IO.puts("Sukces: #{wynik}")
  {:error, powod} -> IO.puts("Błąd: #{powod}")
end

# ------ Konwersja pomiędzy stylami obsługi błędów ------
IO.puts("\n--- Konwersja pomiędzy stylami obsługi błędów ---")

defmodule KonwersjaBledow do
  # Zamiana funkcji zwracającej {:ok, _}/{:error, _} na funkcję rzucającą wyjątek
  def z_tupli_na_wyjatek(fun, args) do
    case apply(fun, args) do
      {:ok, wynik} -> wynik
      {:error, powod} -> raise "Błąd: #{powod}"
    end
  end

  # Zamiana funkcji rzucającej wyjątek na funkcję zwracającą {:ok, _}/{:error, _}
  def z_wyjatku_na_tuple(fun, args) do
    try do
      {:ok, apply(fun, args)}
    rescue
      e -> {:error, Exception.message(e)}
    end
  end
end

# Funkcja z wyjątkami
defmodule FunkcjeRzucajaceWyjatki do
  def podziel(a, b) do
    a / b
  end
end

# Funkcja z tuplami błędów
defmodule FunkcjeZTuplami do
  def podziel(a, b) do
    if b == 0 do
      {:error, "dzielenie przez zero"}
    else
      {:ok, a / b}
    end
  end
end

# Używamy konwersji z tupli na wyjątek
try do
  wynik = KonwersjaBledow.z_tupli_na_wyjatek(&FunkcjeZTuplami.podziel/2, [10, 0])
  IO.puts("Ten kod nie powinien być wykonany")
rescue
  e -> IO.puts("Złapany wyjątek: #{e.message}")
end

# Używamy konwersji z wyjątku na tuplę
przypadek = KonwersjaBledow.z_wyjatku_na_tuple(&FunkcjeRzucajaceWyjatki.podziel/2, [10, 0])
IO.puts("Wynik konwersji wyjątku na tuplę: #{inspect(przypadek)}")

# ------ Atom :ok jako zwyczajna wartość zwrotna ------
IO.puts("\n--- Atom :ok jako zwyczajna wartość zwrotna ---")

defmodule OperacjeBezWynikow do
  def wykonaj_zadanie(argument) do
    if String.valid?(argument) do
      IO.puts("Wykonano zadanie z: #{argument}")
      :ok  # Sygnalizujemy powodzenie
    else
      :error  # Sygnalizujemy niepowodzenie
    end
  end

  def wykonaj_zadanie_z_powodem(argument) do
    if String.valid?(argument) do
      IO.puts("Wykonano zadanie z: #{argument}")
      :ok  # Sygnalizujemy powodzenie
    else
      {:error, "nieprawidłowy argument"}  # Niepowodzenie z powodem
    end
  end
end

# Przykłady użycia
case OperacjeBezWynikow.wykonaj_zadanie("poprawny tekst") do
  :ok -> IO.puts("Zadanie zakończone pomyślnie")
  :error -> IO.puts("Zadanie zakończone niepowodzeniem")
end

case OperacjeBezWynikow.wykonaj_zadanie_z_powodem(<<0xFFFF::16>>) do
  :ok -> IO.puts("Zadanie zakończone pomyślnie")
  {:error, powod} -> IO.puts("Zadanie zakończone niepowodzeniem: #{powod}")
end

# ------ Użycie funkcji pomocniczych ------
IO.puts("\n--- Użycie funkcji pomocniczych ---")

defmodule OperatoryBledow do
  # Operator potoku dla {:ok, _}/{:error, _}
  def then_ok({:ok, value}, fun), do: fun.(value)
  def then_ok({:error, _} = error, _fun), do: error

  # Operator mapowania dla {:ok, _}/{:error, _}
  def map_ok({:ok, value}, fun), do: {:ok, fun.(value)}
  def map_ok({:error, _} = error, _fun), do: error

  # Operator obsługi błędów dla {:ok, _}/{:error, _}
  def handle_error({:ok, _} = ok, _fun), do: ok
  def handle_error({:error, reason}, fun), do: fun.(reason)
end

defmodule PrzykladoweOperacje do
  import OperatoryBledow

  def przetworz_dane(dane) do
    {:ok, dane}
    |> map_ok(fn d -> d * 2 end)
    |> map_ok(fn d -> d + 10 end)
    |> handle_error(fn powod -> {:error, "Obsłużony błąd: #{powod}"} end)
  end

  def pobierz_i_przetworz(id) do
    pobierz_dane(id)
    |> then_ok(fn dane -> przetworz_dane(dane) end)
  end

  def pobierz_dane(id) when id > 0, do: {:ok, id * 100}
  def pobierz_dane(_), do: {:error, "nieprawidłowy identyfikator"}
end

IO.puts("Wynik przetwarzania poprawnych danych: #{inspect(PrzykladoweOperacje.pobierz_i_przetworz(5))}")
IO.puts("Wynik przetwarzania błędnych danych: #{inspect(PrzykladoweOperacje.pobierz_i_przetworz(-1))}")

# ------ Zwracanie wielu rodzajów błędów ------
IO.puts("\n--- Zwracanie wielu rodzajów błędów ---")

defmodule WieleBledow do
  def waliduj_uzytkownika(uzytkownik) do
    with {:ok, _} <- waliduj_imie(uzytkownik.imie),
         {:ok, _} <- waliduj_email(uzytkownik.email),
         {:ok, _} <- waliduj_wiek(uzytkownik.wiek) do
      {:ok, uzytkownik}
    end
  end

  defp waliduj_imie(imie) when is_binary(imie) and byte_size(imie) > 0, do: {:ok, imie}
  defp waliduj_imie(_), do: {:error, {:niepoprawne_imie, "Imię musi być niepustym ciągiem znaków"}}

  defp waliduj_email(email) do
    if String.contains?(email, "@") do
      {:ok, email}
    else
      {:error, {:niepoprawny_email, "Email musi zawierać znak @"}}
    end
  end

  defp waliduj_wiek(wiek) when is_integer(wiek) and wiek >= 18, do: {:ok, wiek}
  defp waliduj_wiek(wiek) when is_integer(wiek), do: {:error, {:niepoprawny_wiek, "Wiek musi być >= 18"}}
  defp waliduj_wiek(_), do: {:error, {:niepoprawny_wiek, "Wiek musi być liczbą całkowitą"}}
end

defmodule ObslugaFormularza do
  def przetworz_uzytkownika(dane) do
    case WieleBledow.waliduj_uzytkownika(dane) do
      {:ok, uzytkownik} ->
        IO.puts("Użytkownik poprawny: #{inspect(uzytkownik)}")
        :ok
      {:error, {typ, komunikat}} ->
        IO.puts("Błąd walidacji (#{typ}): #{komunikat}")
        :error
    end
  end
end

poprawny_uzytkownik = %{imie: "Jan", email: "jan@example.com", wiek: 30}
ObslugaFormularza.przetworz_uzytkownika(poprawny_uzytkownik)

niepoprawny_email = %{imie: "Anna", email: "annaexample.com", wiek: 25}
ObslugaFormularza.przetworz_uzytkownika(niepoprawny_email)

niepoprawny_wiek = %{imie: "Piotr", email: "piotr@example.com", wiek: 16}
ObslugaFormularza.przetworz_uzytkownika(niepoprawny_wiek)

# ------ Wartości vs. wyjątki - kiedy używać ------
IO.puts("\n--- Wartości vs. wyjątki - kiedy używać ---")

defmodule PrzykladyZastosowan do
  # Przypadek 1: Operacje, które często mogą się nie powieść - używamy wartości specjalnych
  def pobierz_z_cache(klucz, cache) do
    case Map.fetch(cache, klucz) do
      {:ok, wartosc} -> {:ok, wartosc}
      :error -> {:error, :brak_klucza}
    end
  end

  # Przypadek 2: Nieprawidłowe API użycie - używamy wyjątków
  def pobierz_element_tablicy!(tablica, indeks) do
    if indeks < 0 or indeks >= length(tablica) do
      raise ArgumentError, "Indeks #{indeks} poza zakresem tablicy"
    end
    Enum.at(tablica, indeks)
  end

  # Przypadek 3: Nieoczekiwane błędy systemowe - pozwalamy wyjątkom się propagować
  def zapisz_plik!(sciezka, dane) do
    File.write!(sciezka, dane)
  end
end

cache = %{"a" => 1, "b" => 2}
IO.puts("Wynik pobrania istniejącego klucza: #{inspect(PrzykladyZastosowan.pobierz_z_cache("a", cache))}")
IO.puts("Wynik pobrania nieistniejącego klucza: #{inspect(PrzykladyZastosowan.pobierz_z_cache("c", cache))}")

try do
  PrzykladyZastosowan.pobierz_element_tablicy!([1, 2, 3], 5)
rescue
  e -> IO.puts("Złapany wyjątek: #{e.message}")
end

IO.puts("\nTo podsumowuje specjalne wartości zwracane w przypadku błędów w Elixir!")
