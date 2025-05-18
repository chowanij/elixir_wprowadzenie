# Podstawy korzystania z Mix

IO.puts("=== Podstawy korzystania z Mix ===\n")

# Mix to narzędzie do zarządzania projektami w Elixir.
# Ten plik daje przegląd podstawowych komend i koncepcji Mix.

IO.puts("""
Uwaga: Ten plik zawiera komendy, które normalnie wpisuje się w terminalu.
Mix jest narzędziem wiersza poleceń, więc większość komend uruchamia się
bezpośrednio w terminalu, a nie w skryptach Elixir.
""")

# ------ Podstawowe komendy Mix ------
IO.puts("\n--- Podstawowe komendy Mix ---")

IO.puts("""
# Tworzenie nowego projektu (aplikacja)
$ mix new nazwa_projektu

# Tworzenie nowej biblioteki (pakiet)
$ mix new nazwa_biblioteki --module NazwaBiblioteki

# Tworzenie nowego projektu z supervisorem (aplikacja OTP)
$ mix new nazwa_projektu --sup

# Kompilacja projektu
$ mix compile

# Uruchamianie aplikacji
$ mix run

# Uruchamianie aplikacji w trybie interaktywnym (IEx)
$ iex -S mix

# Uruchamianie testów
$ mix test

# Czyszczenie plików kompilacji
$ mix clean

# Pobieranie zależności
$ mix deps.get

# Aktualizacja zależności
$ mix deps.update

# Wyświetlanie dostępnych zadań Mix
$ mix help
""")

# ------ Struktura projektu Mix ------
IO.puts("\n--- Przykładowa struktura projektu Mix ---")

IO.puts("""
my_app/                       # Katalog główny projektu
├── _build/                   # Pliki kompilacji (zarządzane przez Mix)
├── config/                   # Konfiguracja aplikacji
│   └── config.exs            # Główny plik konfiguracyjny
├── lib/                      # Kod źródłowy aplikacji
│   ├── my_app.ex             # Moduł główny aplikacji
│   └── my_app/               # Moduły wewnętrzne
│       ├── application.ex    # Kod uruchomieniowy aplikacji OTP
│       └── ...
├── test/                     # Testy
│   ├── test_helper.exs       # Pomocniczy plik testów
│   └── my_app_test.exs       # Testy modułu głównego
├── mix.exs                   # Plik definicji projektu
└── mix.lock                  # Plik blokady wersji zależności
""")

# ------ Plik mix.exs ------
IO.puts("\n--- Struktura pliku mix.exs ---")

IO.puts("""
defmodule MyApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :my_app,               # Nazwa aplikacji jako atom
      version: "0.1.0",           # Wersja aplikacji
      elixir: "~> 1.12",          # Wymagana wersja Elixira
      start_permanent: Mix.env() == :prod,  # Tryb permanent w produkcji
      deps: deps()                # Wywołanie funkcji deps()
    ]
  end

  # Konfiguracja aplikacji OTP
  def application do
    [
      extra_applications: [:logger],  # Dodatkowe aplikacje
      mod: {MyApp.Application, []}    # Moduł startowy aplikacji
    ]
  end

  # Zależności projektu
  defp deps do
    [
      {:ecto, "~> 3.7"},             # Przykładowe zależności
      {:phoenix, "~> 1.6"},
      {:plug_cowboy, "~> 2.0"}
    ]
  end
end
""")

# ------ Środowiska Mix ------
IO.puts("\n--- Środowiska Mix ---")

IO.puts("""
Mix wspiera różne środowiska:
- dev (domyślne) - do rozwoju
- test - do testowania
- prod - do produkcji

Aby uruchomić Mix w konkretnym środowisku:

$ MIX_ENV=test mix compile
$ MIX_ENV=prod mix run

W kodzie można sprawdzić aktualne środowisko:
""")

IO.puts("Aktualne środowisko Mix: #{Mix.env()}")

# ------ Zadania niestandardowe ------
IO.puts("\n--- Tworzenie zadań niestandardowych ---")

IO.puts("""
# W pliku lib/mix/tasks/hello.ex:

defmodule Mix.Tasks.Hello do
  use Mix.Task

  @shortdoc "Po prostu wyświetla przywitanie"
  def run(_) do
    IO.puts "Cześć ze świata Mix tasks!"
  end
end

# Uruchamianie:
$ mix hello
""")

# ------ Aliasy Mix ------
IO.puts("\n--- Aliasy Mix ---")

IO.puts("""
# W pliku mix.exs:

def project do
  [
    # ...
    aliases: aliases()
  ]
end

defp aliases do
  [
    setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
    "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
    "ecto.reset": ["ecto.drop", "ecto.setup"],
    test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
  ]
end

# Uruchamianie:
$ mix setup  # Uruchomi wszystkie komendy zdefiniowane w aliasie
""")

IO.puts("\nTo podsumowuje podstawy używania Mix. Zalecamy eksperymentowanie z tymi komendami w prawdziwym projekcie Mix!")
