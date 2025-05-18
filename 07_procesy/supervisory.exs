# Supervisory w Elixir

IO.puts("=== Supervisory w Elixir ===\n")

# Supervisory są procesami, które monitorują inne procesy i mogą je restartować
# w przypadku błędów. Są kluczowym elementem architektury "let it crash" w Elixir.

# ------ Prosty Supervisor ------
IO.puts("--- Prosty Supervisor ---")

defmodule ProstyPracownik do
  use GenServer

  def start_link(id) do
    GenServer.start_link(__MODULE__, id, name: via_tuple(id))
  end

  def via_tuple(id) do
    {:via, Registry, {MojaPula, "pracownik_#{id}"}}
  end

  def get_id(pid) do
    GenServer.call(pid, :get_id)
  end

  def awaria(pid) do
    GenServer.cast(pid, :awaria)
  end

  # Callbacks

  @impl true
  def init(id) do
    IO.puts("Pracownik #{id} uruchomiony")
    {:ok, %{id: id}}
  end

  @impl true
  def handle_call(:get_id, _from, state) do
    {:reply, state.id, state}
  end

  @impl true
  def handle_cast(:awaria, _state) do
    IO.puts("Pracownik symuluje awarię!")
    # Symulacja błędu
    raise "Błąd w pracowniku!"
  end

  @impl true
  def terminate(reason, state) do
    IO.puts("Pracownik #{state.id} kończy działanie z powodem: #{inspect(reason)}")
    :ok
  end
end

defmodule ProstySupervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    # Najpierw uruchamiamy rejestr do nazw procesów
    children = [
      {Registry, keys: :unique, name: MojaPula},
      {ProstyPracownik, 1},
      {ProstyPracownik, 2},
      {ProstyPracownik, 3}
    ]

    # Strategia one_for_one - jeśli jeden proces się kończy, tylko on jest restartowany
    Supervisor.init(children, strategy: :one_for_one)
  end
end

# Uruchomienie supervisora
{:ok, sup_pid} = ProstySupervisor.start_link([])
IO.puts("Supervisor PID: #{inspect(sup_pid)}")

# Sprawdzenie dzieci supervisora
children = Supervisor.which_children(ProstySupervisor)
IO.puts("\nDzieci supervisora:")

Enum.each(children, fn {id, pid, type, modules} ->
  IO.puts("ID: #{inspect(id)}, PID: #{inspect(pid)}, Typ: #{inspect(type)}, Moduły: #{inspect(modules)}")
end)

# Znalezienie PID pracownika przez rejestr
pid_pracownika = GenServer.whereis(ProstyPracownik.via_tuple(2))
IO.puts("\nPID pracownika 2: #{inspect(pid_pracownika)}")

# Wywołanie awarii w pracowniku
IO.puts("\nWywołanie awarii w pracowniku 2...")
ProstyPracownik.awaria(pid_pracownika)

# Dajmy czas na restart
:timer.sleep(100)

# Sprawdźmy, czy pracownik został zrestartowany
nowy_pid = GenServer.whereis(ProstyPracownik.via_tuple(2))
IO.puts("\nNowy PID pracownika 2 po restarcie: #{inspect(nowy_pid)}")
IO.puts("Czy to ten sam PID? #{nowy_pid == pid_pracownika}")

# ------ Strategie nadzoru ------
IO.puts("\n--- Strategie nadzoru ---")

defmodule PracownikZeZdarzeniami do
  use GenServer

  def start_link({id, parent_pid}) do
    GenServer.start_link(__MODULE__, {id, parent_pid}, name: :"pracownik_#{id}")
  end

  def awaria(pid) do
    GenServer.cast(pid, :awaria)
  end

  # Callbacks

  @impl true
  def init({id, parent_pid}) do
    # Powiadom rodzica o uruchomieniu
    send(parent_pid, {:uruchomiono, id, self()})
    {:ok, %{id: id, parent: parent_pid}}
  end

  @impl true
  def handle_cast(:awaria, state) do
    # Powiadom rodzica o awarii
    send(state.parent, {:awaria, state.id, self()})
    # Symulacja błędu
    raise "Błąd w pracowniku #{state.id}!"
  end

  @impl true
  def terminate(reason, state) do
    # Powiadom rodzica o zakończeniu
    send(state.parent, {:zakonczono, state.id, self(), reason})
    :ok
  end
end

defmodule SupervisorOneForOne do
  use Supervisor

  def start_link(parent_pid) do
    Supervisor.start_link(__MODULE__, parent_pid, name: __MODULE__)
  end

  @impl true
  def init(parent_pid) do
    children = [
      {PracownikZeZdarzeniami, {1, parent_pid}},
      {PracownikZeZdarzeniami, {2, parent_pid}},
      {PracownikZeZdarzeniami, {3, parent_pid}}
    ]

    # Strategia one_for_one - jeśli jeden proces się kończy, tylko on jest restartowany
    Supervisor.init(children, strategy: :one_for_one)
  end
end

defmodule SupervisorOneForAll do
  use Supervisor

  def start_link(parent_pid) do
    Supervisor.start_link(__MODULE__, parent_pid, name: __MODULE__)
  end

  @impl true
  def init(parent_pid) do
    children = [
      {PracownikZeZdarzeniami, {1, parent_pid}},
      {PracownikZeZdarzeniami, {2, parent_pid}},
      {PracownikZeZdarzeniami, {3, parent_pid}}
    ]

    # Strategia one_for_all - jeśli jeden proces się kończy, wszystkie są restartowane
    Supervisor.init(children, strategy: :one_for_all)
  end
end

defmodule SupervisorRestForOne do
  use Supervisor

  def start_link(parent_pid) do
    Supervisor.start_link(__MODULE__, parent_pid, name: __MODULE__)
  end

  @impl true
  def init(parent_pid) do
    children = [
      {PracownikZeZdarzeniami, {1, parent_pid}},
      {PracownikZeZdarzeniami, {2, parent_pid}},
      {PracownikZeZdarzeniami, {3, parent_pid}}
    ]

    # Strategia rest_for_one - jeśli jeden proces się kończy, on i wszystkie po nim są restartowane
    Supervisor.init(children, strategy: :rest_for_one)
  end
end

# Funkcja do testowania różnych strategii
defmodule StrategieTester do
  def test_strategii(nazwa_strategii, modul_supervisora) do
    IO.puts("\nTestowanie strategii: #{nazwa_strategii}")

    # Uruchomienie supervisora z bieżącym procesem jako parent_pid
    {:ok, sup_pid} = apply(modul_supervisora, :start_link, [self()])

    # Zbieramy wiadomości o uruchomieniu
    pidy = collect_startup_messages()
    IO.puts("Uruchomione procesy:")
    Enum.each(pidy, fn {id, pid} -> IO.puts("  Pracownik #{id}: #{inspect(pid)}") end)

    # Wywołujemy awarię w środkowym pracowniku
    IO.puts("\nWywołanie awarii w pracowniku 2...")
    PracownikZeZdarzeniami.awaria(:pracownik_2)

    # Zbieramy wiadomości o awarii i restarcie
    collect_crash_and_restart_messages()

    # Zatrzymujemy supervisor
    Supervisor.stop(sup_pid)

    # Zbieramy wiadomości o zakończeniu
    collect_termination_messages()
  end

  defp collect_startup_messages do
    pidy = for _ <- 1..3 do
      receive do
        {:uruchomiono, id, pid} -> {id, pid}
      after
        1000 -> nil
      end
    end
    Enum.reject(pidy, &is_nil/1)
  end

  defp collect_crash_and_restart_messages do
    # Zbieramy wiadomość o awarii
    receive do
      {:awaria, id, pid} ->
        IO.puts("Otrzymano wiadomość o awarii pracownika #{id}: #{inspect(pid)}")
    after
      1000 -> IO.puts("Brak wiadomości o awarii")
    end

    # Zbieramy wiadomości o zakończeniu
    collect_messages_for_time(500)

    # Zbieramy wiadomości o restarcie
    collect_messages_for_time(500)
  end

  defp collect_termination_messages do
    collect_messages_for_time(500)
  end

  defp collect_messages_for_time(time_ms) do
    receive do
      {:uruchomiono, id, pid} ->
        IO.puts("Otrzymano wiadomość o uruchomieniu pracownika #{id}: #{inspect(pid)}")
        collect_messages_for_time(time_ms)
      {:zakonczono, id, pid, reason} ->
        IO.puts("Otrzymano wiadomość o zakończeniu pracownika #{id}: #{inspect(pid)}, powód: #{inspect(reason)}")
        collect_messages_for_time(time_ms)
      msg ->
        IO.puts("Otrzymano nieoczekiwaną wiadomość: #{inspect(msg)}")
        collect_messages_for_time(time_ms)
    after
      time_ms -> :ok
    end
  end
end

# Testowanie różnych strategii
StrategieTester.test_strategii("one_for_one", SupervisorOneForOne)
StrategieTester.test_strategii("one_for_all", SupervisorOneForAll)
StrategieTester.test_strategii("rest_for_one", SupervisorRestForOne)

# ------ DynamicSupervisor ------
IO.puts("\n--- DynamicSupervisor ---")

defmodule MojDynamicSupervisor do
  use DynamicSupervisor

  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child(id) do
    # Specyfikacja dziecka
    spec = {ProstyPracownik, id}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def count_children do
    DynamicSupervisor.count_children(__MODULE__)
  end
end

# Uruchomienie dynamicznego supervisora
{:ok, dyn_sup} = MojDynamicSupervisor.start_link([])
IO.puts("DynamicSupervisor PID: #{inspect(dyn_sup)}")

# Sprawdzenie początkowej liczby dzieci
counts = MojDynamicSupervisor.count_children()
IO.puts("Początkowa liczba dzieci: #{counts.active}/#{counts.specs}")

# Dynamiczne dodawanie dzieci
for id <- 10..12 do
  {:ok, pid} = MojDynamicSupervisor.start_child(id)
  IO.puts("Dodano dziecko #{id}: #{inspect(pid)}")
end

# Sprawdzenie liczby dzieci po dodaniu
counts = MojDynamicSupervisor.count_children()
IO.puts("Liczba dzieci po dodaniu: #{counts.active}/#{counts.specs}")

# ------ Drzewa nadzoru ------
IO.puts("\n--- Drzewa nadzoru ---")

defmodule PracownikBazy do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_) do
    IO.puts("Pracownik bazy danych uruchomiony")
    {:ok, %{}}
  end
end

defmodule PracownikCache do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_) do
    IO.puts("Pracownik cache uruchomiony")
    {:ok, %{}}
  end
end

defmodule SupervisorBazyDanych do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      {PracownikBazy, []},
      {PracownikCache, []}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end

defmodule PracownikAPI do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_) do
    IO.puts("Pracownik API uruchomiony")
    {:ok, %{}}
  end
end

defmodule SupervisorAPI do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      {PracownikAPI, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

defmodule AplikacjaSupervisor do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      {SupervisorBazyDanych, []},
      {SupervisorAPI, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

# Uruchomienie głównego supervisora
{:ok, app_sup} = AplikacjaSupervisor.start_link([])
IO.puts("Główny supervisor PID: #{inspect(app_sup)}")

# Wyświetlenie drzewa procesów
IO.puts("\nDrzewo procesów:")
IO.puts("AplikacjaSupervisor")
IO.puts("├── SupervisorBazyDanych")
IO.puts("│   ├── PracownikBazy")
IO.puts("│   └── PracownikCache")
IO.puts("└── SupervisorAPI")
IO.puts("    └── PracownikAPI")

IO.puts("\nTo podsumowuje podstawy supervisorów w Elixir!")
