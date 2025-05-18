# Testowanie projektów w Elixir

IO.puts("=== Testowanie projektów w Elixir ===\n")

# Elixir dostarcza framework testowy ExUnit, który jest wbudowany
# w język i ułatwia pisanie różnych rodzajów testów.

# ------ Podstawy ExUnit ------
IO.puts("--- Podstawy ExUnit ---")

IO.puts("""
ExUnit to wbudowany framework testowy dla Elixira.
W każdym projekcie Mix automatycznie generowany jest katalog test/ z podstawową konfiguracją.

# Przykładowy plik test/test_helper.exs:
ExUnit.start()

# Przykładowy test (test/moj_projekt_test.exs):
defmodule MojProjektTest do
  use ExUnit.Case
  doctest MojProjekt

  test "greets the world" do
    assert MojProjekt.hello() == :world
  end
end

# Uruchamianie testów:
$ mix test                   # Uruchomienie wszystkich testów
$ mix test test/nazwa_test.exs         # Uruchomienie konkretnego pliku
$ mix test test/nazwa_test.exs:10      # Uruchomienie testu z linii 10
$ mix test --trace           # Wyświetlanie szczegółowych informacji
$ mix test --stale           # Uruchamianie tylko zmienionych testów
$ mix test --failed          # Uruchamianie tylko nieudanych testów
$ mix test --cover           # Generowanie raportu pokrycia testami
""")

# ------ Struktura testu ------
IO.puts("\n--- Struktura testu ---")

defmodule PrzykladTestu do
  use ExUnit.Case, async: true  # async: true pozwala na równoległe uruchamianie testów

  # Blok setup wykonywany przed każdym testem
  setup do
    # Przygotowanie danych testowych
    user = %{name: "Jan", age: 30}
    # Wartości zwrócone będą dostępne w każdym teście
    {:ok, user: user}
  end

  # Blok setup_all wykonywany raz przed wszystkimi testami w module
  setup_all do
    # Przygotowanie wspólnych zasobów
    {:ok, common_resource: "shared value"}
  end

  # Przykładowy test z metadanymi
  @tag :basic
  test "podstawowy test", %{user: user} do
    assert user.age >= 18
    assert user.name == "Jan"
  end

  # Test z opisową nazwą
  test "sprawdza czy użytkownik jest pełnoletni" do
    assert 30 >= 18
  end

  # Test z kontekstem z setup
  test "używa kontekstu z setup", context do
    assert context[:user].name == "Jan"
    assert context[:common_resource] == "shared value"
  end
end

IO.puts("""
Struktura modułu testowego składa się z:

1. Deklaracji modułu z `use ExUnit.Case`
2. Opcjonalnych bloków setup/setup_all
3. Funkcji testowych zaczynających się od słowa kluczowego `test`
4. Asercji sprawdzających oczekiwania

Katalogi testów powinny odzwierciedlać strukturę kodu źródłowego:

test/
├── my_app/
│   ├── controllers/
│   │   └── user_controller_test.exs
│   └── models/
│       └── user_test.exs
└── test_helper.exs
""")

# ------ Asercje w ExUnit ------
IO.puts("\n--- Asercje w ExUnit ---")

IO.puts("""
ExUnit oferuje różne funkcje asercji:

# Podstawowe asercje
assert(1 + 1 == 2)          # Sprawdza czy wyrażenie jest prawdziwe
refute(1 + 1 == 3)          # Sprawdza czy wyrażenie jest fałszywe

# Porównania
assert 5 > 0
assert "abc" =~ ~r/b/      # =~ sprawdza dopasowanie do wzorca

# Asercje z komunikatem
assert 1 > 2, "1 powinno być większe od 2"

# Asercje wyjątków
assert_raise ArithmeticError, fn ->
  1 / 0
end

# Asercja z konkretnym komunikatem wyjątku
assert_raise ArithmeticError, "bad argument in arithmetic expression", fn ->
  1 / 0
end

# Asercja wyrzucenia/wyjścia (throw/exit)
assert catch_throw(throw 1) == 1
assert catch_exit(exit :normal) == :normal

# Asercje dotyczące różnicy (delta)
assert_in_delta 1.1, 1.2, 0.2

# Asercje dla struktur/map
assert %{name: "Jan"} = %{name: "Jan", age: 30}  # Sprawdza dopasowanie wzorca
""")

# ------ Mockowanie i stuby ------
IO.puts("\n--- Mockowanie i stuby ---")

IO.puts("""
Elixir nie ma wbudowanych narzędzi do mockowania, ale istnieją biblioteki, które to umożliwiają:

1. Mox - oficjalna biblioteka do mockowania zachowań:

```elixir
# Dodaj do mix.exs
defp deps do
  [{:mox, "~> 1.0", only: :test}]
end

# Definiowanie mocka
defmodule MyApp.MockHTTPClient do
  use Mox.Defmock, for: MyApp.HTTPClient
end

# Używanie w teście
test "uses HTTP client" do
  Mox.expect(MyApp.MockHTTPClient, :get, fn url ->
    assert url == "https://example.com"
    {:ok, %{status: 200, body: "ok"}}
  end)

  assert MyApp.fetch_data() == {:ok, "ok"}
end
```

2. Alternatywnie, można używać agentów i dynamicznych dispatcherów:

```elixir
defmodule MockableHTTP do
  def get(url), do: impl().get(url)
  defp impl, do: Application.get_env(:my_app, :http_client)
end

# W teście:
Application.put_env(:my_app, :http_client, MockHTTP)

defmodule MockHTTP do
  def get("https://example.com"), do: {:ok, %{status: 200, body: "ok"}}
end
```
""")

# ------ Testy doktryn (doctest) ------
IO.puts("\n--- Testy doktryn (doctest) ---")

IO.puts("""
ExUnit umożliwia testowanie przykładów w dokumentacji:

```elixir
defmodule Matematyka do
  @moduledoc \"\"\"
  Moduł z funkcjami matematycznymi.
  \"\"\"

  @doc \"\"\"
  Dodaje dwie liczby.

  ## Przykłady

      iex> Matematyka.dodaj(1, 2)
      3

      iex> Matematyka.dodaj(-1, 1)
      0
  \"\"\"
  def dodaj(a, b), do: a + b
end
```

W teście używamy:

```elixir
defmodule MatematykaTest do
  use ExUnit.Case
  doctest Matematyka  # Automatycznie testuje przykłady z dokumentacji
end
```

Zalety:
- Zawsze aktualna dokumentacja
- Przykłady są weryfikowane przez testy
- Dokumentacja i testy w jednym
""")

# ------ Testy właściwości (property testing) ------
IO.puts("\n--- Testy właściwości (property testing) ---")

IO.puts("""
Testy właściwości pozwalają testować właściwości funkcji dla wielu danych wejściowych:

# Dodaj StreamData do zależności
# {:stream_data, "~> 0.5", only: :test}

```elixir
defmodule PropertyTest do
  use ExUnit.Case
  use ExUnitProperties

  property "konwersja na string i z powrotem dla liczb całkowitych" do
    check all number <- integer() do
      assert number == number |> to_string() |> String.to_integer()
    end
  end

  property "sortowanie nie zmienia długości listy" do
    check all list <- list_of(integer()) do
      assert length(list) == length(Enum.sort(list))
    end
  end
end
```

Zalety:
- Odkrywanie trudnych do przewidzenia błędów
- Automatyczne generowanie danych testowych
- Testowanie właściwości zamiast konkretnych przypadków
""")

# ------ Testowanie asynchronizmu i procesów ------
IO.puts("\n--- Testowanie asynchronizmu i procesów ---")

IO.puts("""
ExUnit dostarcza narzędzia do testowania kodu asynchronicznego:

```elixir
defmodule AsyncTest do
  use ExUnit.Case

  test "otrzymuje wiadomość" do
    # Wysłanie wiadomości do bieżącego procesu
    send(self(), {:hello, "world"})

    # Sprawdzenie czy wiadomość została otrzymana
    assert_receive {:hello, "world"}, 100  # timeout w ms
  end

  test "nie otrzymuje niepożądanej wiadomości" do
    refute_receive {:unwanted}, 100
  end

  test "sprawdza zawartość skrzynki odbiorczej" do
    send(self(), {:msg1, "hello"})
    send(self(), {:msg2, "world"})

    # Sprawdza otrzymane wiadomości bez ich usuwania ze skrzynki
    assert_received {:msg1, "hello"}
    assert_received {:msg2, "world"}
  end
end
```

Do testowania genserverów i procesów OTP:

```elixir
defmodule KalkulatorServer do
  use GenServer

  # ... implementacja GenServer ...

  def start_link(args), do: GenServer.start_link(__MODULE__, args)
  def add(pid, a, b), do: GenServer.call(pid, {:add, a, b})
end

defmodule KalkulatorServerTest do
  use ExUnit.Case

  test "kalkulator dodaje liczby" do
    {:ok, pid} = KalkulatorServer.start_link([])
    assert KalkulatorServer.add(pid, 2, 3) == 5
  end
end
```
""")

# ------ Dobre praktyki testowania ------
IO.puts("\n--- Dobre praktyki testowania ---")

IO.puts("""
1. Używaj `setup` i `setup_all` do współdzielenia konfiguracji

2. Organizuj testy w tematyczne grupy używając tagów:
   ```elixir
   @tag :integration
   test "integracja z API" do
     # ...
   end

   # Uruchamianie wybranych testów:
   $ mix test --only integration
   $ mix test --exclude integration
   ```

3. Dla dużych projektów, trzymaj testy integracyjne oddzielnie:
   ```
   test/
   ├── unit/         # Szybkie testy jednostkowe
   ├── integration/  # Wolniejsze testy integracyjne
   └── test_helper.exs
   ```

4. Używaj fixtures do przygotowania złożonych danych testowych:
   ```elixir
   defmodule Fixtures do
     def user_fixture(attrs \\\\ %{}) do
       default = %{name: "Jan", email: "jan@example.com"}
       user = Map.merge(default, attrs)
       {:ok, user} = Users.create_user(user)
       user
     end
   end

   # Użycie:
   user = Fixtures.user_fixture(%{role: :admin})
   ```

5. Mierz pokrycie kodu testami:
   ```
   $ mix test --cover
   ```

6. W testach priorytetyzuj czytelność nad zwięzłością

7. Dla testów HTTP używaj bibliotek takich jak `bypass` do mockowania zewnętrznych API
""")

# ------ ExUnit Callbacks ------
IO.puts("\n--- ExUnit Callbacks ---")

IO.puts("""
ExUnit oferuje kilka callbacków do zarządzania stanem testowym:

```elixir
defmodule CallbacksTest do
  use ExUnit.Case

  setup do
    IO.puts("Uruchamiany przed każdym testem")
    :ok
  end

  setup_all do
    IO.puts("Uruchamiany tylko raz, przed wszystkimi testami")
    :ok
  end

  on_exit(fn ->
    IO.puts("Uruchamiany po teście, nawet jeśli test się nie powiedzie")
  end)

  test "test 1" do
    # ...
  end

  test "test 2" do
    # ...
  end
end
```

Zwracanie wartości z callbacków:
```elixir
setup do
  # Zwracamy kontekst, który będzie dostępny w każdym teście
  {:ok, conn: Phoenix.ConnTest.build_conn(), user: create_user()}
end

# W teście:
test "używanie kontekstu", %{conn: conn, user: user} do
  # ...
end
```
""")

IO.puts("\nTo podsumowuje testowanie projektów w Elixir!")
