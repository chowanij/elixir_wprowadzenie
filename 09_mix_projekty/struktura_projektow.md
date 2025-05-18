# Struktura projektów Mix

## Podstawowa struktura

Gdy tworzymy nowy projekt Mix za pomocą komendy `mix new nazwa_projektu`, automatycznie generowana jest następująca struktura katalogów:

```
nazwa_projektu/
├── .formatter.exs          # Konfiguracja formatowania kodu
├── .gitignore              # Ignorowane pliki w Git
├── README.md               # Dokumentacja projektu
├── lib/                    # Kod źródłowy projektu
│   └── nazwa_projektu.ex   # Główny moduł projektu
├── mix.exs                 # Definicja projektu Mix
└── test/                   # Testy
    ├── nazwa_projektu_test.exs  # Testy dla głównego modułu
    └── test_helper.exs          # Konfiguracja testów
```

## Rozszerzona struktura

Dla bardziej rozwiniętych projektów, struktura może wyglądać tak:

```
nazwa_projektu/
├── .formatter.exs          # Konfiguracja formatowania kodu
├── .gitignore              # Ignorowane pliki w Git
├── README.md               # Dokumentacja projektu
├── _build/                 # Pliki kompilacji (generowane przez Mix)
├── config/                 # Konfiguracja aplikacji
│   ├── config.exs          # Główna konfiguracja
│   ├── dev.exs             # Konfiguracja dla środowiska dev
│   ├── prod.exs            # Konfiguracja dla środowiska prod
│   └── test.exs            # Konfiguracja dla środowiska test
├── deps/                   # Zależności projektu (generowane)
├── lib/                    # Kod źródłowy projektu
│   ├── nazwa_projektu.ex   # Główny moduł projektu
│   └── nazwa_projektu/     # Moduły wewnętrzne
│       ├── application.ex  # Moduł aplikacji OTP (dla --sup)
│       ├── supervisor.ex   # Główny supervisor (dla --sup)
│       └── ...             # Inne moduły
├── mix.exs                 # Definicja projektu Mix
├── mix.lock                # Zablokowane wersje zależności
└── test/                   # Testy
    ├── nazwa_projektu_test.exs  # Testy dla głównego modułu
    └── test_helper.exs          # Konfiguracja testów
```

## Typy projektów Mix

### 1. Aplikacja (standardowa)

Podstawowy typ projektu, tworzony przez:

```bash
mix new nazwa_projektu
```

Zawiera minimalną strukturę pokazaną w pierwszym przykładzie.

### 2. Aplikacja OTP z supervisorem

```bash
mix new nazwa_projektu --sup
```

Ten rodzaj projektu dodatkowo zawiera moduły aplikacji i supervisora:

```
lib/
├── nazwa_projektu.ex        # Główny moduł projektu
└── nazwa_projektu/
    ├── application.ex       # Moduł aplikacji OTP
    └── supervisor.ex        # Główny supervisor
```

W pliku `mix.exs` pojawia się dodatkowo:

```elixir
def application do
  [
    mod: {NazwaProjektu.Application, []},
    extra_applications: [:logger]
  ]
end
```

### 3. Biblioteka (pakiet)

```bash
mix new nazwa_biblioteki --module NazwaBiblioteki
```

Struktura jest podobna do standardowej aplikacji, ale w `mix.exs` nie ma konfiguracji `mod:` w sekcji `application`.

### 4. Umbrella project

```bash
mix new nazwa_umbrella --umbrella
```

Tworzy specjalny rodzaj projektu, który może zawierać wiele podprojektów:

```
nazwa_umbrella/
├── apps/                # Katalog na podprojekty
│   ├── app1/           # Podprojekt 1
│   │   ├── lib/
│   │   ├── mix.exs
│   │   └── test/
│   └── app2/           # Podprojekt 2
│       ├── lib/
│       ├── mix.exs
│       └── test/
├── config/             # Wspólna konfiguracja
└── mix.exs             # Definicja projektu umbrella
```

## Ważne pliki w projekcie Mix

### mix.exs

Najważniejszy plik projektu Mix, definiujący jego konfigurację:

```elixir
defmodule MojProjekt.MixProject do
  use Mix.Project

  def project do
    [
      app: :moj_projekt,        # Nazwa aplikacji
      version: "0.1.0",         # Wersja
      elixir: "~> 1.12",        # Wymagana wersja Elixir
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      # Opcjonalne pola:
      description: "Opis projektu",
      package: package(),       # Konfiguracja dla publikacji w Hex
      aliases: aliases(),       # Aliasy komend Mix
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test]
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {MojProjekt.Application, []}
    ]
  end

  defp deps do
    [
      {:inny_pakiet, "~> 1.0"}
    ]
  end
end
```

### .formatter.exs

Konfiguracja formatowania kodu:

```elixir
[
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  line_length: 98
]
```

### config/config.exs

Główny plik konfiguracyjny:

```elixir
import Config

config :nazwa_aplikacji,
  key1: "value1",
  key2: "value2"

import_config "#{config_env()}.exs"
```

## Dobre praktyki organizacji kodu

1. **Podkatalogi w `lib/`** - organizuj kod w logicznej strukturze folderów:

```
lib/
├── nazwa_projektu/
│   ├── models/          # Modele danych
│   ├── controllers/     # Kontrolery (dla aplikacji web)
│   ├── services/        # Usługi biznesowe
│   └── utils/           # Narzędzia pomocnicze
└── nazwa_projektu.ex    # Główny moduł, fasada do innych modułów
```

2. **Katalogi specjalne**:

- `priv/` - zasoby, które powinny być uwzględnione w wydaniu (np. pliki migracji, statyczne)
- `docs/` - dodatkowa dokumentacja projektu
- `scripts/` - skrypty pomocnicze (np. deploy, automatyzacja)
- `rel/` - konfiguracja wydań (releases)

3. **Testy**:

```
test/
├── nazwa_projektu/
│   ├── models/          # Testy dla modeli
│   └── services/        # Testy dla usług
├── integration/         # Testy integracyjne
├── support/             # Kod pomocniczy do testów
└── test_helper.exs
```

Dobra organizacja kodu jest kluczowa dla skalowalności projektu. Warto zacząć od prostej struktury i rozbudowywać ją stopniowo, gdy projekt rośnie. 