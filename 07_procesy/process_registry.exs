# Rejestracja i nazywanie procesów w Elixir

IO.puts("=== Rejestracja i nazywanie procesów w Elixir ===\n")

# W Elixir procesy są identyfikowane przez PID, ale często potrzebujemy
# bardziej wygodnego sposobu odnoszenia się do procesów - przez nazwę.

# ------ Rejestracja procesów za pomocą Process.register/2 ------
IO.puts("--- Rejestracja procesów za pomocą Process.register/2 ---")

# Tworzymy proces
pid = spawn(fn ->
  receive do
    msg -> IO.puts("Proces otrzymał wiadomość: #{inspect(msg)}")
  end
end)

# Rejestrujemy proces pod nazwą :moj_proces
Process.register(pid, :moj_proces)
IO.puts("Proces zarejestrowany jako :moj_proces")

# Teraz możemy wysłać wiadomość używając nazwy zamiast PID
send(:moj_proces, "Witaj, nazwany procesie!")
:timer.sleep(100)

# Sprawdzenie, czy proces jest zarejestrowany
if Process.whereis(:moj_proces) do
  IO.puts("Proces :moj_proces istnieje")
else
  IO.puts("Proces :moj_proces nie istnieje")
end

# Wyrejestrowanie procesu
Process.unregister(:moj_proces)
IO.puts("Proces wyrejestrowany")

# Sprawdzenie po wyrejestrowaniu
if Process.whereis(:moj_proces) do
  IO.puts("Proces :moj_proces nadal istnieje")
else
  IO.puts("Proces :moj_proces nie istnieje po wyrejestrowaniu")
end

# ------ Ograniczenia rejestracji procesów ------
IO.puts("\n--- Ograniczenia rejestracji procesów ---")

# 1. Nazwa musi być atomem
# 2. Można zarejestrować tylko jeden proces pod daną nazwą
# 3. Proces może być zarejestrowany tylko pod jedną nazwą

# Tworzenie dwóch procesów
pid1 = spawn(fn -> :timer.sleep(5000) end)
pid2 = spawn(fn -> :timer.sleep(5000) end)

# Rejestracja pierwszego procesu
Process.register(pid1, :testowy_proces)
IO.puts("Proces 1 zarejestrowany jako :testowy_proces")

# Próba rejestracji drugiego procesu pod tą samą nazwą
try do
  Process.register(pid2, :testowy_proces)
  IO.puts("Proces 2 zarejestrowany jako :testowy_proces")
catch
  :error, reason ->
    IO.puts("Błąd rejestracji: #{inspect(reason)}")
end

# Wyrejestrowanie pierwszego procesu
Process.unregister(:testowy_proces)

# Teraz możemy zarejestrować drugi proces
Process.register(pid2, :testowy_proces)
IO.puts("Proces 2 zarejestrowany jako :testowy_proces po wyrejestrowaniu procesu 1")

# Czyszczenie
Process.unregister(:testowy_proces)

# ------ Używanie GenServer z nazwą ------
IO.puts("\n--- Używanie GenServer z nazwą ---")

defmodule NazwanyServer do
  use GenServer

  # API klienta
  def start_link(nazwa \\ __MODULE__) do
    GenServer.start_link(__MODULE__, [], name: nazwa)
  end

  def get_state(nazwa \\ __MODULE__) do
    GenServer.call(nazwa, :get_state)
  end

  def increment(nazwa \\ __MODULE__) do
    GenServer.cast(nazwa, :increment)
  end

  # Callbacks serwera
  @impl true
  def init([]) do
    {:ok, 0}
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast(:increment, state) do
    {:noreply, state + 1}
  end
end

# Uruchamiamy serwer z domyślną nazwą (NazwanyServer)
{:ok, pid} = NazwanyServer.start_link()
IO.puts("Uruchomiono serwer z PID: #{inspect(pid)}")

# Używamy funkcji API bez podawania PID
NazwanyServer.increment()
stan = NazwanyServer.get_state()
IO.puts("Stan serwera: #{stan}")

# Uruchamiamy drugi serwer z inną nazwą
{:ok, pid2} = NazwanyServer.start_link(:drugi_serwer)
IO.puts("Uruchomiono drugi serwer z PID: #{inspect(pid2)}")

# Używamy funkcji API z podaną nazwą
NazwanyServer.increment(:drugi_serwer)
NazwanyServer.increment(:drugi_serwer)
stan = NazwanyServer.get_state(:drugi_serwer)
IO.puts("Stan drugiego serwera: #{stan}")

# ------ Moduł Registry ------
IO.puts("\n--- Moduł Registry ---")

# Moduł Registry zapewnia bardziej zaawansowany mechanizm rejestracji procesów
# Pozwala na rejestrację wielu procesów pod różnymi kluczami w ramach jednego rejestru

# Uruchomienie rejestru
{:ok, registry} = Registry.start_link(keys: :unique, name: MojRejestr)
IO.puts("Uruchomiono rejestr: #{inspect(registry)}")

# Tworzenie procesów i rejestracja ich w rejestrze
for id <- 1..3 do
  pid = spawn(fn ->
    receive do
      {:msg, content} -> IO.puts("Proces #{id} otrzymał wiadomość: #{content}")
    end
  end)

  Registry.register(MojRejestr, "proces_#{id}", id)
  IO.puts("Zarejestrowano proces #{id} (#{inspect(pid)}) pod kluczem \"proces_#{id}\"")
end

# Wyszukiwanie procesu po kluczu
case Registry.lookup(MojRejestr, "proces_2") do
  [{pid, value}] ->
    IO.puts("Znaleziono proces pod kluczem \"proces_2\": #{inspect(pid)}, wartość: #{value}")
    send(pid, {:msg, "Witaj, proces 2!"})
  [] ->
    IO.puts("Nie znaleziono procesu pod kluczem \"proces_2\"")
end

:timer.sleep(100)

# ------ Via tuple ------
IO.puts("\n--- Via tuple ---")

# Via tuple to mechanizm pozwalający na używanie różnych rejestrów procesów
# z GenServer i innymi zachowaniami OTP

defmodule ViaServer do
  use GenServer

  def start_link(id) do
    GenServer.start_link(__MODULE__, id, name: via_tuple(id))
  end

  def via_tuple(id) do
    {:via, Registry, {MojRejestr, "serwer_#{id}"}}
  end

  def get_id(id) do
    GenServer.call(via_tuple(id), :get_id)
  end

  def ping(id) do
    GenServer.cast(via_tuple(id), :ping)
  end

  # Callbacks

  @impl true
  def init(id) do
    {:ok, %{id: id, pings: 0}}
  end

  @impl true
  def handle_call(:get_id, _from, state) do
    {:reply, {state.id, state.pings}, state}
  end

  @impl true
  def handle_cast(:ping, state) do
    new_state = %{state | pings: state.pings + 1}
    IO.puts("Serwer #{state.id} otrzymał ping, licznik: #{new_state.pings}")
    {:noreply, new_state}
  end
end

# Uruchamiamy kilka serwerów
for id <- [:a, :b, :c] do
  {:ok, pid} = ViaServer.start_link(id)
  IO.puts("Uruchomiono ViaServer #{id} z PID: #{inspect(pid)}")
end

# Używamy serwerów przez ich identyfikatory
ViaServer.ping(:a)
ViaServer.ping(:b)
ViaServer.ping(:b)
:timer.sleep(100)

# Pobieramy informacje o serwerach
for id <- [:a, :b, :c] do
  {server_id, pings} = ViaServer.get_id(id)
  IO.puts("Serwer #{server_id} ma #{pings} pingów")
end

# ------ Partitioned Registry ------
IO.puts("\n--- Partitioned Registry ---")

# Rejestr partycjonowany pozwala na lepszą wydajność w systemach rozproszonych
{:ok, partitioned_registry} = Registry.start_link(
  keys: :unique,
  name: PartycjonowanyRejestr,
  partitions: System.schedulers_online()  # Liczba partycji równa liczbie rdzeni
)

IO.puts("Uruchomiono rejestr partycjonowany z #{System.schedulers_online()} partycjami")

# Rejestracja procesów
for id <- 1..5 do
  pid = spawn(fn -> :timer.sleep(10_000) end)
  Registry.register(PartycjonowanyRejestr, "worker_#{id}", %{role: :worker})
  IO.puts("Zarejestrowano worker_#{id}: #{inspect(pid)}")
end

# Zliczanie procesów w rejestrze
count = Registry.count(PartycjonowanyRejestr)
IO.puts("Liczba procesów w rejestrze partycjonowanym: #{count}")

# Pobieranie wszystkich kluczy
keys = Registry.keys(PartycjonowanyRejestr, self())
IO.puts("Klucze dla bieżącego procesu: #{inspect(keys)}")

# ------ Dispatch Registry ------
IO.puts("\n--- Dispatch Registry ---")

# Rejestr typu dispatch pozwala na rejestrację wielu procesów pod tym samym kluczem
{:ok, dispatch_registry} = Registry.start_link(
  keys: :duplicate,
  name: DispatchRejestr
)

IO.puts("Uruchomiono rejestr typu dispatch")

# Rejestracja wielu procesów pod tym samym kluczem
for id <- 1..3 do
  pid = spawn(fn ->
    receive do
      msg -> IO.puts("Subskrybent #{id} otrzymał: #{inspect(msg)}")
    end
  end)

  Registry.register(DispatchRejestr, :powiadomienia, id)
  IO.puts("Zarejestrowano subskrybenta #{id} (#{inspect(pid)}) dla :powiadomienia")
end

# Wysłanie wiadomości do wszystkich procesów pod danym kluczem
Registry.dispatch(DispatchRejestr, :powiadomienia, fn entries ->
  for {pid, id} <- entries do
    send(pid, "Powiadomienie dla subskrybenta #{id}")
  end
end)

:timer.sleep(100)

IO.puts("\nTo podsumowuje rejestrację i nazywanie procesów w Elixir!")
