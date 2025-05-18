# Tworzenie aplikacji OTP z Mix

IO.puts("=== Tworzenie aplikacji OTP z Mix ===\n")

# Elixir i platforma OTP doskonale nadają się do budowania
# skalowalnych i odpornych na awarie aplikacji.

# ------ Wprowadzenie do aplikacji OTP ------
IO.puts("--- Wprowadzenie do aplikacji OTP ---")

IO.puts("""
OTP (Open Telecom Platform) to zbiór bibliotek i wzorców projektowych
do budowania aplikacji współbieżnych i rozproszonych.

Aplikacja OTP w Elixir to aplikacja, która:
- Posiada drzewo nadzoru (supervision tree)
- Może być uruchamiana i zatrzymywana jako całość
- Jest zarządzana przez BEAM (maszynę wirtualną Erlanga)
- Może zależeć od innych aplikacji OTP

Tworzenie aplikacji OTP z supervisorem:

$ mix new nazwa_aplikacji --sup
""")

# ------ Struktura aplikacji OTP ------
IO.puts("\n--- Struktura aplikacji OTP ---")

IO.puts("""
Po utworzeniu projektu z flagą --sup, Mix generuje strukturę:

nazwa_aplikacji/
├── lib/
│   ├── nazwa_aplikacji.ex             # Moduł główny
│   └── nazwa_aplikacji/
│       ├── application.ex             # Moduł aplikacji
│       └── supervisor.ex              # Główny supervisor
├── mix.exs
└── ... (inne pliki i katalogi)

Moduł aplikacji (application.ex) definiuje funkcję start/2:

defmodule MojaAplikacja.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Lista procesów potomnych (children)
      # {MojaAplikacja.Worker, arg}
    ]

    opts = [strategy: :one_for_one, name: MojaAplikacja.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

W pliku mix.exs mamy:

def application do
  [
    mod: {MojaAplikacja.Application, []},
    extra_applications: [:logger]
  ]
end
""")

# ------ Komponenty aplikacji OTP ------
IO.puts("\n--- Komponenty aplikacji OTP ---")

IO.puts("""
Typowa aplikacja OTP zawiera różne komponenty:

1. Supervisory - nadzorują procesy i restartują je w przypadku awarii
2. GenServer - ogólny serwer do obsługi zapytań i stanu
3. Task - jednorazowe zadania
4. Agent - proste przechowywanie stanu
5. Registry - rejestracja i wyszukiwanie procesów
6. DynamicSupervisor - supervisor dla procesów tworzonych dynamicznie
""")

# ------ Supervisory i strategie nadzoru ------
IO.puts("\n--- Supervisory i strategie nadzoru ---")

defmodule PrzykladSupervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      # Statyczny child spec
      {PrzykladowyWorker, arg: :wartosc},

      # Child spec jako mapa
      %{
        id: PracownikA,
        start: {PracownikA, :start_link, [%{nazwa: "A"}]},
        restart: :permanent,
        shutdown: 5000,
        type: :worker
      },

      # Child spec jako lista (starszy format)
      Supervisor.child_spec(
        {PracownikB, %{nazwa: "B"}},
        id: :custom_id,
        restart: :temporary
      )
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

IO.puts("""
Strategie nadzoru:

- :one_for_one - Jeśli proces potomny ulegnie awarii, tylko on zostanie zrestartowany
- :one_for_all - Jeśli proces ulegnie awarii, wszystkie procesy potomne są restartowane
- :rest_for_one - Jeśli proces ulegnie awarii, ten proces i wszystkie procesy po nim są restartowane

Opcje restartu:

- :permanent - Proces zawsze jest restartowany (domyślnie)
- :temporary - Proces nigdy nie jest restartowany
- :transient - Proces jest restartowany tylko gdy zakończy się nieprawidłowo
""")

# ------ Przykład aplikacji OTP ------
IO.puts("\n--- Przykład aplikacji OTP: System bankowy ---")

IO.puts("""
Poniżej znajduje się struktura przykładowej aplikacji bankowej:

```
bank_app/
├── lib/
│   ├── bank_app.ex                      # Fasada API
│   └── bank_app/
│       ├── application.ex               # Moduł aplikacji
│       ├── supervisor.ex                # Główny supervisor
│       ├── account_supervisor.ex        # Supervisor kont
│       ├── account.ex                   # GenServer konta
│       ├── transaction_processor.ex     # Moduł przetwarzania transakcji
│       └── user_session.ex              # Moduł sesji użytkownika
├── mix.exs
└── ...
```

Przykład modułu aplikacji:

```elixir
defmodule BankApp.Application do
  use Application

  def start(_type, _args) do
    children = [
      # Supervisor kont
      BankApp.AccountSupervisor,

      # Rejestr kont
      {Registry, keys: :unique, name: BankApp.AccountRegistry},

      # Serwer sesji
      {BankApp.SessionServer, %{timeout: 3600}},

      # Dispatcher transakcji
      {BankApp.TransactionDispatcher, []},

      # Dynamiczny supervisor dla procesów transakcji
      {DynamicSupervisor,
        strategy: :one_for_one,
        name: BankApp.TransactionSupervisor}
    ]

    opts = [strategy: :one_for_one, name: BankApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
```

Przykład modułu konta (używając GenServer):

```elixir
defmodule BankApp.Account do
  use GenServer
  require Logger

  # API Klienta
  def start_link(account_id) do
    GenServer.start_link(__MODULE__, %{id: account_id, balance: 0, transactions: []},
      name: via_tuple(account_id)
    )
  end

  def via_tuple(account_id) do
    {:via, Registry, {BankApp.AccountRegistry, account_id}}
  end

  def deposit(account_id, amount) do
    GenServer.call(via_tuple(account_id), {:deposit, amount})
  end

  def withdraw(account_id, amount) do
    GenServer.call(via_tuple(account_id), {:withdraw, amount})
  end

  def get_balance(account_id) do
    GenServer.call(via_tuple(account_id), :balance)
  end

  # Implementacja callbacks
  @impl true
  def init(state) do
    Logger.info("Inicjalizacja konta #{state.id}")
    {:ok, state}
  end

  @impl true
  def handle_call({:deposit, amount}, _from, state) do
    if amount <= 0 do
      {:reply, {:error, :invalid_amount}, state}
    else
      new_balance = state.balance + amount
      new_state = %{state |
        balance: new_balance,
        transactions: [{:deposit, amount, DateTime.utc_now()} | state.transactions]
      }

      {:reply, {:ok, new_balance}, new_state}
    end
  end

  @impl true
  def handle_call({:withdraw, amount}, _from, state) do
    cond do
      amount <= 0 ->
        {:reply, {:error, :invalid_amount}, state}
      amount > state.balance ->
        {:reply, {:error, :insufficient_funds}, state}
      true ->
        new_balance = state.balance - amount
        new_state = %{state |
          balance: new_balance,
          transactions: [{:withdraw, amount, DateTime.utc_now()} | state.transactions]
        }

        {:reply, {:ok, new_balance}, new_state}
    end
  end

  @impl true
  def handle_call(:balance, _from, state) do
    {:reply, {:ok, state.balance}, state}
  end
end
```
""")

# ------ Testowanie aplikacji OTP ------
IO.puts("\n--- Testowanie aplikacji OTP ---")

IO.puts("""
Testowanie aplikacji OTP wymaga specjalnego podejścia:

```elixir
defmodule BankApp.AccountTest do
  use ExUnit.Case

  setup do
    # Uruchomienie instancji aplikacji tylko do testów
    start_supervised!({Registry, keys: :unique, name: BankApp.AccountRegistry})
    start_supervised!(BankApp.AccountSupervisor)

    # Utworzenie testowego konta
    account_id = "test-123"
    BankApp.create_account(account_id)

    # Przeprowadzenie testów ze świeżo utworzonym kontem
    %{account_id: account_id}
  end

  test "depozyt na konto", %{account_id: account_id} do
    assert {:ok, 0} = BankApp.get_balance(account_id)
    assert {:ok, 100} = BankApp.deposit(account_id, 100)
    assert {:ok, 100} = BankApp.get_balance(account_id)
  end

  test "wypłata z konta", %{account_id: account_id} do
    BankApp.deposit(account_id, 200)
    assert {:ok, 100} = BankApp.withdraw(account_id, 100)
    assert {:ok, 100} = BankApp.get_balance(account_id)
    assert {:error, :insufficient_funds} = BankApp.withdraw(account_id, 200)
  end
end
```

W testach pomocne funkcje z modułu `ExUnit.Callbacks`:
- `start_supervised!/2` - uruchamia proces pod nadzorem testowego supervisora
- `stop_supervised/1` - zatrzymuje nadzorowany proces
""")

# ------ Application Callbacks ------
IO.puts("\n--- Application Callbacks ---")

IO.puts("""
Moduł Application definiuje kilka opcjonalnych callbacków:

```elixir
defmodule MojaAplikacja.Application do
  use Application

  # Wymagany callback - uruchamiany przy starcie aplikacji
  @impl true
  def start(_type, _args) do
    # ... inicjalizacja drzewa nadzoru ...
  end

  # Opcjonalny callback - uruchamiany przy zatrzymaniu aplikacji
  @impl true
  def stop(_state) do
    # Sprzątanie zasobów
    :ok
  end

  # Funkcja pomocnicza do konfiguracji
  def config(key, default \\\\ nil) do
    Application.get_env(:moja_aplikacja, key, default)
  end
end
```

Typy uruchomienia aplikacji (_type w start/2):
- :normal - standardowe uruchomienie
- {:takeover, node} - przejęcie od innego węzła
- {:failover, node} - awaryjne przejęcie po awarii węzła
""")

# ------ Rozproszone aplikacje OTP ------
IO.puts("\n--- Rozproszone aplikacje OTP ---")

IO.puts("""
Aplikacje OTP mają wbudowane wsparcie dla systemów rozproszonych:

```elixir
# Łączenie węzłów
Node.connect(:"app1@192.168.1.100")

# Sprawdzanie połączonych węzłów
Node.list()

# Uruchamianie kodu na zdalnym węźle
:rpc.call(:"app1@192.168.1.100", Modul, :funkcja, [args])

# Monitorowanie zdalnych procesów
Node.monitor(:"app1@192.168.1.100", true)
```

Tworzenie klastra:

```
# Startowanie węzła z nazwą i cookie
$ iex --name app1@192.168.1.100 --cookie secret_cookie -S mix

# Na innym serwerze:
$ iex --name app2@192.168.1.101 --cookie secret_cookie -S mix

# W konsoli app2:
iex(app2@192.168.1.101)> Node.connect(:"app1@192.168.1.100")
true
```

libcluster - biblioteka do automatycznego formowania klastrów:

```elixir
# W mix.exs:
{:libcluster, "~> 3.3"}

# W application.ex:
children = [
  {Cluster.Supervisor, [
    [
      strategy: Cluster.Strategy.Epmd,
      config: [
        hosts: [:"app1@127.0.0.1", :"app2@127.0.0.1"]
      ]
    ]
  ]},
  # ... inne procesy ...
]
```
""")

# ------ Releases ------
IO.puts("\n--- Releases (wydania) ---")

IO.puts("""
Mix oferuje wbudowane wsparcie dla wydań (releases):

```
# Generowanie konfiguracji wydania
$ mix release.init

# Budowanie wydania
$ MIX_ENV=prod mix release

# Uruchamianie wydania
$ _build/prod/rel/my_app/bin/my_app start

# Tworzenie wydania z konfiguracją runtime.exs
$ MIX_ENV=prod mix release --overwrite
```

Korzyści z wydań:
- Samowystarczalne pakiety (nie wymagają Elixir/Erlang na serwerze)
- Szybszy start aplikacji
- Gorące aktualizacje kodu (hot upgrades)
- Narzędzia do zarządzania (start, stop, restart, remote_console)
- Wbudowane wsparcie dla wielu środowisk

Plik config/runtime.exs dla konfiguracji w czasie wykonania:

```elixir
import Config

if config_env() == :prod do
  config :my_app, port: System.fetch_env!("PORT")
  config :my_app, secret_key: System.fetch_env!("SECRET_KEY")
end
```

Polecamy bibliotekę Distillery dla bardziej zaawansowanych opcji wydań:
https://github.com/bitwalker/distillery
""")

IO.puts("\nTo podsumowuje tworzenie aplikacji OTP z Mix!")
