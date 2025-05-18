# Konstrukcja with do obsługi błędów

IO.puts("=== Konstrukcja with do obsługi błędów ===\n")

# Konstrukcja with pozwala na eleganckie składanie operacji
# które mogą zakończyć się błędem i wczesne wyjście z sekwencji

# ------ Podstawy konstrukcji with ------
IO.puts("--- Podstawy konstrukcji with ---")

# Przykład użycia with dla sekwencji operacji
defmodule PrzykladyWith do
  def prosty_przyklad(mapa) do
    with {:ok, a} <- Map.fetch(mapa, :a),
         {:ok, b} <- Map.fetch(mapa, :b),
         {:ok, c} <- Map.fetch(mapa, :c) do
      # Ta część wykonuje się tylko jeśli wszystkie operacje się powiodły
      {:ok, a + b + c}
    end
  end
end

mapa_poprawna = %{a: 1, b: 2, c: 3}
mapa_bledna = %{a: 1, b: 2}

IO.puts("Wynik poprawny: #{inspect(PrzykladyWith.prosty_przyklad(mapa_poprawna))}")
IO.puts("Wynik błędny: #{inspect(PrzykladyWith.prosty_przyklad(mapa_bledna))}")

# ------ Klauzula else w with ------
IO.puts("\n--- Klauzula else w with ---")

defmodule WithElse do
  def przyklad_z_else(mapa) do
    with {:ok, a} <- Map.fetch(mapa, :a),
         {:ok, b} <- Map.fetch(mapa, :b),
         {:ok, c} <- Map.fetch(mapa, :c) do
      {:ok, a + b + c}
    else
      :error -> {:error, "Brak wymaganego klucza"}
      err -> {:error, "Inny błąd: #{inspect(err)}"}
    end
  end
end

IO.puts("Wynik z else (poprawny): #{inspect(WithElse.przyklad_z_else(mapa_poprawna))}")
IO.puts("Wynik z else (błędny): #{inspect(WithElse.przyklad_z_else(mapa_bledna))}")

# ------ Przypisania zmiennych w with ------
IO.puts("\n--- Przypisania zmiennych w with ---")

defmodule WithPrzypisania do
  def przyklad_z_przypisaniami(mapa) do
    with {:ok, a} <- Map.fetch(mapa, :a),
         suma_a = a + 10,  # Proste przypisanie
         {:ok, b} <- Map.fetch(mapa, :b),
         suma_ab = suma_a + b, # Możemy używać wcześniejszych zmiennych
         {:ok, c} <- Map.fetch(mapa, :c) do
      {:ok, suma_ab + c}
    else
      :error -> {:error, "Brak wymaganego klucza"}
    end
  end
end

IO.puts("Wynik z przypisaniami: #{inspect(WithPrzypisania.przyklad_z_przypisaniami(mapa_poprawna))}")

# ------ Zagnieżdżone dopasowania wzorców ------
IO.puts("\n--- Zagnieżdżone dopasowania wzorców ---")

defmodule WithZagniezdzoneDopasowania do
  def przetworz_dane(dane) do
    with %{user: user} <- dane,
         %{name: name, age: age} when age >= 18 <- user do
      {:ok, "Użytkownik #{name} jest pełnoletni (#{age} lat)"}
    else
      %{user: %{name: name, age: age}} when age < 18 ->
        {:error, "Użytkownik #{name} jest niepełnoletni (#{age} lat)"}
      %{user: %{}} ->
        {:error, "Użytkownik nie posiada wymaganych pól"}
      _ ->
        {:error, "Nieprawidłowy format danych"}
    end
  end
end

dane_poprawne = %{user: %{name: "Jan", age: 25}}
dane_niepelnoletni = %{user: %{name: "Piotr", age: 16}}
dane_niepoprawne = %{user: %{}}

IO.puts("Wynik poprawny: #{inspect(WithZagniezdzoneDopasowania.przetworz_dane(dane_poprawne))}")
IO.puts("Wynik niepełnoletni: #{inspect(WithZagniezdzoneDopasowania.przetworz_dane(dane_niepelnoletni))}")
IO.puts("Wynik niepoprawny: #{inspect(WithZagniezdzoneDopasowania.przetworz_dane(dane_niepoprawne))}")

# ------ Użycie with do walidacji danych ------
IO.puts("\n--- Użycie with do walidacji danych ---")

defmodule Walidacja do
  def waliduj_wiek(wiek) when is_integer(wiek) and wiek >= 18, do: {:ok, wiek}
  def waliduj_wiek(wiek) when is_integer(wiek), do: {:error, "Wiek musi być >= 18"}
  def waliduj_wiek(_), do: {:error, "Wiek musi być liczbą całkowitą"}

  def waliduj_email(email) when is_binary(email) do
    if String.contains?(email, "@") do
      {:ok, email}
    else
      {:error, "Email musi zawierać znak @"}
    end
  end
  def waliduj_email(_), do: {:error, "Email musi być ciągiem znaków"}

  def waliduj_uzytkownika(uzytkownik) do
    with {:ok, wiek} <- waliduj_wiek(uzytkownik[:wiek]),
         {:ok, email} <- waliduj_email(uzytkownik[:email]) do
      {:ok, %{wiek: wiek, email: email}}
    end
  end
end

uzytkownik1 = %{wiek: 25, email: "jan@example.com"}
uzytkownik2 = %{wiek: 16, email: "piotr@example.com"}
uzytkownik3 = %{wiek: 20, email: "invalid-email"}

IO.puts("Walidacja uzytkownik1: #{inspect(Walidacja.waliduj_uzytkownika(uzytkownik1))}")
IO.puts("Walidacja uzytkownik2: #{inspect(Walidacja.waliduj_uzytkownika(uzytkownik2))}")
IO.puts("Walidacja uzytkownik3: #{inspect(Walidacja.waliduj_uzytkownika(uzytkownik3))}")

# ------ Łączenie with z innymi konstrukcjami ------
IO.puts("\n--- Łączenie with z innymi konstrukcjami ---")

defmodule WithKombinacje do
  # Symulacja funkcji do pobrania użytkownika z bazy
  def pobierz_uzytkownika(id) when id > 0 and id <= 100 do
    {:ok, %{id: id, imie: "Użytkownik #{id}"}}
  end
  def pobierz_uzytkownika(_), do: {:error, "Użytkownik nie znaleziony"}

  # Symulacja funkcji do pobrania uprawnień
  def pobierz_uprawnienia(uzytkownik) do
    case uzytkownik do
      %{id: id} when rem(id, 2) == 0 -> {:ok, [:czytanie, :pisanie, :usuwanie]}
      %{id: _} -> {:ok, [:czytanie]}
      _ -> {:error, "Nie można pobrać uprawnień"}
    end
  end

  # Funkcja sprawdzająca uprawnienia z użyciem with i case
  def sprawdz_dostep(uzytkownik_id, wymagane_uprawnienia) do
    with {:ok, uzytkownik} <- pobierz_uzytkownika(uzytkownik_id),
         {:ok, uprawnienia} <- pobierz_uprawnienia(uzytkownik) do
      case Enum.all?(wymagane_uprawnienia, &(&1 in uprawnienia)) do
        true -> {:ok, "Dostęp przyznany dla #{uzytkownik.imie}"}
        false -> {:error, "Brak wystarczających uprawnień"}
      end
    else
      {:error, powod} -> {:error, powod}
    end
  end
end

IO.puts("Dostęp dla użytkownika 2 ([:czytanie]): #{inspect(WithKombinacje.sprawdz_dostep(2, [:czytanie]))}")
IO.puts("Dostęp dla użytkownika 2 ([:usuwanie]): #{inspect(WithKombinacje.sprawdz_dostep(2, [:usuwanie]))}")
IO.puts("Dostęp dla użytkownika 1 ([:usuwanie]): #{inspect(WithKombinacje.sprawdz_dostep(1, [:usuwanie]))}")
IO.puts("Dostęp dla użytkownika 999: #{inspect(WithKombinacje.sprawdz_dostep(999, [:czytanie]))}")

# ------ Praktyczny przykład: przetwarzanie formularza ------
IO.puts("\n--- Praktyczny przykład: przetwarzanie formularza ---")

defmodule PrzetwarzanieFormularza do
  # Walidacja danych formularza
  def waliduj_imie(imie) when is_binary(imie) and byte_size(imie) > 0 do
    {:ok, imie}
  end
  def waliduj_imie(_), do: {:error, "Imię jest wymagane"}

  def waliduj_email(email) when is_binary(email) do
    if String.match?(email, ~r/@.+\..+$/) do
      {:ok, email}
    else
      {:error, "Niepoprawny format email"}
    end
  end
  def waliduj_email(_), do: {:error, "Email jest wymagany"}

  def waliduj_haslo(haslo) when is_binary(haslo) and byte_size(haslo) >= 8 do
    {:ok, haslo}
  end
  def waliduj_haslo(haslo) when is_binary(haslo) do
    {:error, "Hasło musi mieć co najmniej 8 znaków"}
  end
  def waliduj_haslo(_), do: {:error, "Hasło jest wymagane"}

  # Symulacja zapisu do bazy danych
  def zapisz_uzytkownika(dane) do
    # W rzeczywistej aplikacji, tutaj byłaby operacja zapisu do bazy
    {:ok, %{id: :rand.uniform(1000), inserted_at: DateTime.utc_now()} |> Map.merge(dane)}
  end

  # Główna funkcja przetwarzająca dane formularza
  def zarejestruj_uzytkownika(formularz) do
    with {:ok, imie} <- waliduj_imie(formularz[:imie]),
         {:ok, email} <- waliduj_email(formularz[:email]),
         {:ok, haslo} <- waliduj_haslo(formularz[:haslo]),
         dane_uzytkownika = %{imie: imie, email: email, zaszyfrowane_haslo: "zaszyfrowane: #{haslo}"},
         {:ok, uzytkownik} <- zapisz_uzytkownika(dane_uzytkownika) do
      {:ok, %{wiadomosc: "Rejestracja zakończona pomyślnie", uzytkownik: uzytkownik}}
    else
      {:error, powod} -> {:error, %{wiadomosc: "Błąd rejestracji", powod: powod}}
    end
  end
end

formularz_poprawny = %{imie: "Jan Kowalski", email: "jan@example.com", haslo: "tajnehaslo123"}
formularz_bledny_email = %{imie: "Jan Kowalski", email: "niepoprawny_email", haslo: "tajnehaslo123"}
formularz_bledne_haslo = %{imie: "Jan Kowalski", email: "jan@example.com", haslo: "123"}

IO.puts("Rejestracja poprawna: #{inspect(PrzetwarzanieFormularza.zarejestruj_uzytkownika(formularz_poprawny))}")
IO.puts("Rejestracja z błędnym email: #{inspect(PrzetwarzanieFormularza.zarejestruj_uzytkownika(formularz_bledny_email))}")
IO.puts("Rejestracja z błędnym hasłem: #{inspect(PrzetwarzanieFormularza.zarejestruj_uzytkownika(formularz_bledne_haslo))}")

# ------ Zalety i wady with ------
IO.puts("\n--- Zalety i wady with ---")

IO.puts("Zalety konstrukcji with:")
IO.puts("1. Eliminuje kaskadowe zagnieżdżone case/if wyrażenia")
IO.puts("2. Poprawia czytelność kodu obsługującego wiele możliwych błędów")
IO.puts("3. Pozwala na eleganckie wczesne opuszczenie sekwencji")
IO.puts("4. Zmienne zdefiniowane wcześniej są dostępne w kolejnych krokach")

IO.puts("\nWady konstrukcji with:")
IO.puts("1. Może być trudniejsza do zrozumienia dla początkujących")
IO.puts("2. Dla prostych przypadków może być nadmiarowa")
IO.puts("3. Bez klauzuli else nie zawsze jest jasne, jaki błąd został zwrócony")
IO.puts("4. Dla bardzo złożonych warunków może być trudna do utrzymania")

IO.puts("\nTo podsumowuje konstrukcję with do obsługi błędów w Elixir!")
