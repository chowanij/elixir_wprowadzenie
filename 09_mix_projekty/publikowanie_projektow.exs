# Publikowanie pakietów w Elixir

IO.puts("=== Publikowanie pakietów w Elixir ===\n")

# Hex to oficjalny rejestr pakietów dla ekosystemu Elixir i Erlang,
# umożliwiający publikację i dzielenie się kodem z innymi.

# ------ Przygotowanie pakietu do publikacji ------
IO.puts("--- Przygotowanie pakietu do publikacji ---")

IO.puts("""
Przed publikacją pakietu w Hex, należy odpowiednio przygotować projekt:

1. Upewnij się, że twój kod jest przechowywany w publicznym repozytorium Git
2. Dodaj plik LICENSE z licencją open source (np. MIT, Apache 2.0)
3. Przygotuj plik README.md z dobrym opisem projektu
4. Przygotuj dokumentację kodu używając ExDoc
5. Zaktualizuj mix.exs z metadanymi pakietu
""")

# ------ Konfiguracja mix.exs ------
IO.puts("\n--- Konfiguracja mix.exs ---")

IO.puts("""
Aby przygotować projekt do publikacji, należy zaktualizować plik mix.exs:

```elixir
defmodule MojPakiet.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/username/moj_pakiet"

  def project do
    [
      app: :moj_pakiet,
      version: @version,
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Wymagane dla publikacji w Hex
      description: description(),
      package: package(),

      # Opcje dla dokumentacji
      name: "MojPakiet",
      source_url: @source_url,
      homepage_url: "https://twojastronainternetowa.com",
      docs: docs()
    ]
  end

  defp description() do
    \"\"\"
    Krótki, zwięzły opis biblioteki (2-3 zdania).
    Powinien wyjaśniać cel i główne funkcje pakietu.
    \"\"\"
  end

  defp package() do
    [
      name: "moj_pakiet",
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE),
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url,
        "Dokumentacja" => "https://hexdocs.pm/moj_pakiet"
      }
    ]
  end

  defp docs() do
    [
      main: "readme",
      logo: "path/to/logo.png",
      extras: ["README.md", "CHANGELOG.md"],
      authors: ["Imię Nazwisko"],
      source_ref: "v\#{@version}",
      groups_for_modules: [
        "Główne moduły": [
          MojPakiet,
          MojPakiet.Core
        ],
        "Pomocnicze": [
          MojPakiet.Helpers
        ]
      ]
    ]
  end

  defp deps() do
    [
      # Zależności wymagane tylko do dokumentacji
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      # Pozostałe zależności...
    ]
  end
end
```
""")

# ------ Przygotowanie dokumentacji ------
IO.puts("\n--- Przygotowanie dokumentacji ---")

IO.puts("""
Dokumentacja w Elixirze jest bardzo ważna - Hex automatycznie publikuje ją na hexdocs.pm:

```elixir
defmodule MojPakiet do
  @moduledoc \"\"\"
  Główny moduł pakietu.

  Ten moduł zapewnia główne funkcje do wykonywania operacji X i Y.
  \"\"\"

  @doc \"\"\"
  Przykładowa funkcja pakietu.

  ## Parametry

  - `arg1`: Opis pierwszego parametru
  - `arg2`: Opis drugiego parametru

  ## Przykłady

      iex> MojPakiet.funkcja("tekst", 42)
      {:ok, "wynik"}

      iex> MojPakiet.funkcja("niepoprawny", -1)
      {:error, "nieprawidłowy argument"}

  ## Zwracane wartości

  Tuple {:ok, wynik} w przypadku powodzenia, {:error, powod} w przypadku błędu.
  \"\"\"
  def funkcja(arg1, arg2) do
    # implementacja
  end

  @doc \"\"\"
  Kolejna funkcja.

  Ten komentarz będzie wyświetlany w dokumentacji.
  \"\"\"
  @spec inna_funkcja(String.t()) :: boolean()
  def inna_funkcja(tekst) do
    # implementacja
  end
end
```

Aby wygenerować dokumentację lokalnie:

$ mix docs
""")

# ------ Publikowanie pakietu ------
IO.puts("\n--- Publikowanie pakietu ---")

IO.puts("""
Krok po kroku, jak opublikować pakiet w Hex:

1. Najpierw należy się zarejestrować (jeśli jeszcze tego nie zrobiłeś):

   $ mix hex.user register

2. Zaloguj się do swojego konta Hex:

   $ mix hex.user auth

3. Zbuduj i opublikuj pakiet:

   $ mix hex.publish

   Ten polecenie:
   - Kompiluje projekt
   - Sprawdza czy wszystko jest skonfigurowane poprawnie
   - Buduje paczkę
   - Wysyła ją do rejestru Hex
   - Generuje i wysyła dokumentację do hexdocs.pm

4. Jeśli chcesz opublikować tylko dokumentację (np. po aktualizacji README):

   $ mix hex.publish docs
""")

# ------ Zarządzanie wersjami ------
IO.puts("\n--- Zarządzanie wersjami ---")

IO.puts("""
Hex wymaga semantycznego wersjonowania (SemVer):

MAJOR.MINOR.PATCH

- MAJOR: Niekompatybilne zmiany API
- MINOR: Nowa funkcjonalność, kompatybilna wstecz
- PATCH: Naprawy błędów, kompatybilne wstecz

Przykład procesu wydania nowej wersji:

1. Zaktualizuj wersję w mix.exs:
   ```elixir
   def project do
     [
       app: :moj_pakiet,
       version: "0.2.0",
       # ...
     ]
   end
   ```

2. Zaktualizuj CHANGELOG.md z opisem zmian

3. Utwórz tag w Git:
   ```
   $ git add .
   $ git commit -m "Wersja 0.2.0"
   $ git tag v0.2.0
   $ git push origin master --tags
   ```

4. Opublikuj nową wersję:
   ```
   $ mix hex.publish
   ```
""")

# ------ Zarządzanie pakietami prywatnymi ------
IO.puts("\n--- Zarządzanie pakietami prywatnymi ---")

IO.puts("""
Dla pakietów wewnętrznych/prywatnych możesz użyć:

1. Hex Private - płatna usługa od hex.pm:
   ```
   # Konfiguracja organizacji
   $ mix hex.organization auth acme

   # Publikowanie pakietu prywatnego
   $ mix hex.publish --organization acme
   ```

2. Używanie repozytoriów Git zamiast Hex:
   ```elixir
   # W mix.exs:
   defp deps do
     [
       {:moj_pakiet_wewnetrzny, git: "https://github.com/mojafirma/moj_pakiet_wewnetrzny.git"},
       # Konkretna wersja (branch/tag/commit):
       {:inny_pakiet, git: "https://github.com/mojafirma/inny_pakiet.git", tag: "v0.1.0"}
     ]
   end
   ```

3. Prywatny serwer Hex:
   - Skonfiguruj własny serwer Hex (np. [Hexpm](https://github.com/hexpm/hexpm))
   - Skonfiguruj klienta mix do korzystania z tego serwera
""")

# ------ Dobre praktyki publikowania pakietów ------
IO.puts("\n--- Dobre praktyki publikowania pakietów ---")

IO.puts("""
1. **Dokładnie testuj kod**
   - Upewnij się, że twój pakiet ma dobre pokrycie testami
   - Uruchom testy na różnych wersjach Elixir

2. **Pisz przejrzystą dokumentację**
   - Dokładnie opisuj API
   - Dodawaj przykłady użycia dla każdej funkcji
   - Utrzymuj aktualny plik README

3. **Używaj typespecs**
   - Dokumentuj typy dla wszystkich publicznych funkcji
   - Używaj Dialectica lub Dialyzera do sprawdzania typów

4. **Zarządzaj zależnościami ostrożnie**
   - Używaj elastycznych ograniczeń wersji dla zależności
   - Nie dodawaj zbędnych zależności
   - Testuj kompatybilność z najnowszymi wersjami zależności

5. **Utrzymuj Changelog**
   - Dokumentuj wszystkie zmiany w CHANGELOG.md
   - Wyjaśniaj zmiany łamiące kompatybilność

6. **Zaangażuj społeczność**
   - Odpowiadaj na zgłoszenia i pull requesty
   - Dokumentuj proces przyczyniania się do projektu w CONTRIBUTING.md
""")

# ------ Przykładowa struktura dobrego pakietu ------
IO.puts("\n--- Przykładowa struktura dobrego pakietu ---")

IO.puts("""
```
moj_pakiet/
├── .formatter.exs
├── .gitignore
├── CHANGELOG.md           # Historia zmian
├── CODE_OF_CONDUCT.md     # Zasady zachowania w społeczności
├── CONTRIBUTING.md        # Instrukcje dla kontrybutorów
├── LICENSE                # Licencja (np. MIT)
├── README.md              # Główna dokumentacja
├── lib/                   # Kod źródłowy
│   ├── moj_pakiet.ex
│   └── moj_pakiet/
│       ├── core.ex
│       └── helpers.ex
├── mix.exs
└── test/                  # Testy
    ├── moj_pakiet_test.exs
    └── test_helper.exs
```

Kluczowe elementy które powinieneś uwzględniać:

- README.md z kompletną dokumentacją dla początkujących
- Dokładnie opisane publiczne API
- Przykłady użycia w dokumentacji
- Adekwatne testy
- CHANGELOG.md dla śledzenia zmian
- Jasna licencja
- Sensowna organizacja kodu
""")

# ------ Promocja pakietu ------
IO.puts("\n--- Promocja pakietu ---")

IO.puts("""
Po opublikowaniu pakietu warto:

1. Ogłosić to na forach i grupach Elixira:
   - Forum Elixir: https://elixirforum.com/
   - Reddit: r/elixir
   - Discord Elixir
   - Twitter/X z hashtagiem #elixirlang

2. Napisać post na blogu o swoim pakiecie:
   - Wyjaśnić problemy, które rozwiązuje
   - Pokazać przykłady użycia
   - Opisać proces tworzenia i decyzje projektowe

3. Przygotować stronę demonstracyjną (jeśli dotyczy):
   - Interaktywny przykład użycia
   - Pokazać wyniki działania pakietu

4. Utrzymywać pakiet:
   - Regularnie aktualizować do nowych wersji Elixira
   - Odpowiadać na zgłoszenia problemów
   - Rozwijać pakiet zgodnie z potrzebami użytkowników
""")

IO.puts("\nTo podsumowuje publikowanie pakietów w Elixir!")
