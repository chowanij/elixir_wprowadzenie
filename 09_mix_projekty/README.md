# Mix i Projekty w Elixir

## Wprowadzenie

Mix to narzędzie do tworzenia, kompilacji i zarządzania projektami Elixir. Jest dołączone do Elixira i zapewnia zintegrowany sposób na:

- Tworzenie nowych projektów
- Zarządzanie zależnościami
- Kompilację kodu
- Uruchamianie testów
- Tworzenie zadań niestandardowych (tasks)
- Publikowanie pakietów

Mix jest dla Elixira tym, czym Cargo dla Rust, npm dla Node.js, czy Gradle dla Javy.

## Zawartość katalogu

Ten katalog zawiera materiały dotyczące pracy z Mix i projektami w Elixir:

1. `podstawy_mix.exs` - podstawowe komendy i funkcjonalności Mix
2. `struktura_projektow.md` - opis typowej struktury projektów Mix
3. `dependency_management.exs` - zarządzanie zależnościami w projektach
4. `testowanie_projektow.exs` - wprowadzenie do testowania z ExUnit
5. `tworzenie_aplikacji.exs` - tworzenie aplikacji OTP z Mix
6. `publikowanie_projektow.exs` - jak publikować swoje pakiety Hexie

## Dlaczego warto używać Mix?

Mix znacznie upraszcza proces tworzenia aplikacji w Elixir:

- **Standardowa struktura** - Mix tworzy standardową strukturę katalogów, co ułatwia organizację kodu i współpracę
- **Automatyzacja** - Mix automatyzuje wiele zadań, takich jak kompilacja, testowanie i zarządzanie zależnościami
- **Rozszerzalność** - można tworzyć własne zadania do automatyzacji specyficznych procesów
- **Integracja** - Mix dobrze integruje się z innymi narzędziami ekosystemu Elixir

## Kiedy używać Mix?

Mix powinien być używany praktycznie zawsze, gdy tworzymy aplikacje Elixir, które:
- Mają być rozwijane w czasie
- Korzystają z zewnętrznych bibliotek
- Mają być testowane
- Mogą być publikowane jako pakiety

Jedynymi wyjątkami są proste skrypty i jednorazowe programy, które można pisać jako pojedyncze pliki .exs.

## Korzyści z używania projektów Mix

- Łatwiejsze zarządzanie kodem, gdy projekt rośnie
- Standaryzacja struktury, co ułatwia wprowadzenie nowych osób do projektu
- Dostęp do wielu gotowych narzędzi (kompilacja, testy, dokumentacja)
- Możliwość tworzenia aplikacji OTP zgodnych z ekosystemem Erlang 