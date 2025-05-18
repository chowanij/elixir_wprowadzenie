# Zarządzanie zależnościami w projektach Mix

IO.puts("=== Zarządzanie zależnościami w projektach Mix ===\n")

# Mix umożliwia zarządzanie zależnościami projektu poprzez system
# pakietów Hex oraz poprzez Git lub inne źródła.

# ------ Deklarowanie zależności w projekcie ------
IO.puts("--- Deklarowanie zależności w projekcie ---")

IO.puts("""
W pliku mix.exs definiujemy zależności w funkcji deps:

defmodule MojProjekt.MixProject do
  use Mix.Project

  def project do
    [
      app: :moj_projekt,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Tutaj definiujemy zależności
  defp deps do
    [
      # Podstawowe definicje zależności
      {:phoenix, "~> 1.6"},             # Z pakietu Hex z określoną wersją
      {:plug, ">= 1.5.0 and < 2.0.0"},  # Z Hex, zakres wersji
      {:cowboy, "~> 2.0", optional: true}, # Opcjonalna zależność

      # Zależności z repozytorium Git
      {:mojlib, git: "https://github.com/user/mojlib.git"},
      {:mojlib, git: "https://github.com/user/mojlib.git", branch: "master"},
      {:mojlib, git: "https://github.com/user/mojlib.git", tag: "v1.0.0"},
      {:mojlib, git: "https://github.com/user/mojlib.git", ref: "c2d7e7c"},

      # Zależności lokalne (z systemu plików)
      {:mojlib, path: "../mojlib"},

      # Zależności tylko dla określonego środowiska
      {:ex_doc, "~> 0.26", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end
end
""")

# ------ Komendy do zarządzania zależnościami ------
IO.puts("\n--- Komendy do zarządzania zależnościami ---")

IO.puts("""
# Pobieranie wszystkich zależności
$ mix deps.get

# Aktualizacja zależności
$ mix deps.update --all           # Wszystkie zależności
$ mix deps.update phoenix plug    # Tylko wybrane zależności

# Kompilacja zależności
$ mix deps.compile

# Czyszczenie zależności
$ mix deps.clean --all            # Wszystkie zależności
$ mix deps.clean phoenix --build  # Tylko pliki kompilacji dla phoenix

# Wyświetlanie statusu zależności
$ mix deps
$ mix deps.tree                   # Wyświetla drzewo zależności

# Aktualizacja pliku mix.lock
$ mix deps.update --all
""")

# ------ Plik mix.lock ------
IO.puts("\n--- Plik mix.lock ---")

IO.puts("""
Mix generuje plik mix.lock, który zapewnia powtarzalność kompilacji
przez zablokowanie dokładnych wersji wszystkich zależności:

%{
  "cowboy": {:hex, :cowboy, "2.9.0", "865dd8b6607e14cf03282e10e934023a1bd8be6f6bacf921a7e2a96d800cd452", [:make, :rebar3], [{:cowlib, "2.11.0", [hex: :cowlib, repo: "hexpm", optional: false]}, {:ranch, "1.8.0", [hex: :ranch, repo: "hexpm", optional: false]}], "hexpm", "2c729f934b4e1aa149aff882f57c6372c15399a20d54f65c8d67bef583021bde"},
  "cowlib": {:hex, :cowlib, "2.11.0", "0b9ff9c346629256c42ebe1eeb769a83c6cb771a6ee5960bd110ab0b9b872063", [:make, :rebar3], [], "hexpm", "2b3e9da1cf7aec26c2a0f4e293dace2d3d9e056f9f32fe20d4215a3147bafafd"},
  "phoenix": {:hex, :phoenix, "1.6.1", "4c59e0123d92028486900f0d2cb23d99enriched36aec0dd30e24f39d76cffa45d5", [:mix], [...], "hexpm", "c52f5f1c01dcd71aa3928e047b432020c2879b31c2111a9846ef0c48c2fce09c"},
  "ranch": {:hex, :ranch, "1.8.0", "8c7a100a139fd57f17327b6413e4167ac559fbc04ca7448e9be9057311597a1d", [:make, :rebar3], [], "hexpm", "49fbcfd3682fab1f5d109351b61257676da1a2fdbe295904176d5e521a2ddfe5"},
}

Ten plik powinien być załączony do kontroli wersji, aby zapewnić,
że każdy deweloper i środowisko CI używa dokładnie tych samych wersji pakietów.
""")

# ------ Zarządzanie wersjami zależności ------
IO.puts("\n--- Zarządzanie wersjami zależności ---")

IO.puts("""
Elixir używa operatorów specyfikacji wersji:

* "== 2.0.0" - dokładnie wersja 2.0.0
* ">= 2.0.0" - wersja 2.0.0 lub wyższa
* "<= 3.0.0" - wersja 3.0.0 lub niższa
* "~> 2.0.0" - wersja 2.0.0 lub wyższa, ale < 2.1.0
* "~> 2.1"   - wersja 2.1.0 lub wyższa, ale < 3.0.0
* ">= 2.0.0 and <= 3.0.0" - pomiędzy 2.0.0 i 3.0.0 włącznie

Zalecane podejścia:

* Dla bibliotek: używaj "~>" aby pozwolić na aktualizacje drobne
* Dla aplikacji: możesz być bardziej rygorystyczny, używając "=="
""")

# ------ Rozwiązywanie konfliktów zależności ------
IO.puts("\n--- Rozwiązywanie konfliktów zależności ---")

IO.puts("""
Jeśli wystąpią konflikty wersji zależności, Mix wyświetli ostrzeżenie:

$ mix deps.get
Resolving Hex dependencies...
Dependency resolution failed:
  ...
  * mix.lock specifies cowboy 2.8.0, but 2.9.0 is required by:
    phoenix 1.6.1

Jak rozwiązać konflikty:

1. Zaktualizować własne wymagania, aby były bardziej elastyczne:
   {:cowboy, "~> 2.8"} zamiast {:cowboy, "== 2.8.0"}

2. Wymusić określoną wersję za pomocą override:

   defp deps do
     [
       {:phoenix, "~> 1.6"},
       {:cowboy, "~> 2.8", override: true}  # Ta wersja ma pierwszeństwo
     ]
   end
""")

# ------ Hex - menedżer pakietów ------
IO.puts("\n--- Hex - menedżer pakietów ---")

IO.puts("""
Hex to oficjalny menedżer pakietów dla ekosystemu Elixir.

# Instalacja Hex (jednorazowo):
$ mix local.hex

# Wyszukiwanie pakietów:
$ mix hex.search phoenix

# Informacje o pakiecie:
$ mix hex.info phoenix

# Publikowanie własnego pakietu:
$ mix hex.publish

# Konfiguracja uwierzytelniania:
$ mix hex.user register
$ mix hex.user auth
""")

# ------ Własne pakiety ------
IO.puts("\n--- Tworzenie własnych pakietów ---")

IO.puts("""
Aby przygotować projekt do publikacji jako pakiet Hex, dodaj w mix.exs:

defmodule MojPakiet.MixProject do
  use Mix.Project

  def project do
    [
      app: :moj_pakiet,
      version: "0.1.0",
      description: "Opis mojego pakietu",
      package: package(),  # Konfiguracja pakietu
      deps: deps()
    ]
  end

  defp package do
    [
      maintainers: ["Jan Kowalski"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/jankowalski/moj_pakiet",
        "Docs" => "https://hexdocs.pm/moj_pakiet"
      },
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE)
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.24", only: :dev, runtime: false}
    ]
  end
end
""")

# ------ Obsługa zależności dziedziczonych ------
IO.puts("\n--- Obsługa zależności dziedziczonych ---")

IO.puts("""
W dużych projektach, możesz chcieć kontrolować zależności dziedziczone:

* Aby sprawdzić całe drzewo zależności:
  $ mix deps.tree

* Aby sprawdzić, które pakiety zależą od konkretnej biblioteki:
  $ mix deps.tree --only cowboy

* Aby zobaczyć nieużywane zależności:
  $ mix deps.unlock --check-unused

* Aby usunąć nieużywane zależności z mix.lock:
  $ mix deps.clean --unlock --unused

Zachowaj ostrożność przy usuwaniu zależności, które mogą być używane pośrednio.
""")

IO.puts("\nTo podsumowuje zarządzanie zależnościami w projektach Mix!")
