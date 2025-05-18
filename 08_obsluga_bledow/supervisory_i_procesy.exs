# Wykorzystanie supervisorów do obsługi błędów w procesach

IO.puts("=== Wykorzystanie supervisorów do obsługi błędów w procesach ===\n")

# W Elixir zasada "let it crash" jest fundamentalna - zamiast obsługiwać wszystkie
# możliwe błędy w procesie, pozwalamy mu się zakończyć i polegamy na mechanizmach
# supervisorów do jego restartowania.

# ------ Podstawowe podejście ------
IO.puts("--- Podstawowe podejście ---")

defmodule PrzykladyObslugi do
  # Funkcja, która może wyrzucić wyjątek
  def niebezpieczna_operacja(input) do
    case input do
      :ok -> {:ok, "Operacja udana"}
      :blad -> raise "Wystąpił błąd podczas operacji"
      _ -> {:error, "Nieznany przypadek"}
    end
  end

  # Tradycyjny sposób obsługi błędów - try/rescue
  def tradycyjna_obsluga(input) do
    try do
      niebezpieczna_operacja(input)
    rescue
      e -> {:error, "Złapany wyjątek: #{Exception.message(e)}"}
    end
  end

  # Podejście "let it crash" w procesie
  def proces_z_obsluga_bledow(input, parent_pid) do
    spawn(fn ->
      wynik = try do
        niebezpieczna_operacja(input)
      rescue
        e -> {:error, "Złapany wyjątek: #{Exception.message(e)}"}
      end
      send(parent_pid, {:wynik, wynik})
    end)
  end

  # Podejście "let it crash" bez obsługi wyjątku w procesie
  def proces_bez_obslugi_bledow(input, parent_pid) do
    spawn_monitor(fn ->
      wynik = niebezpieczna_operacja(input)
      send(parent_pid, {:wynik, wynik})
    end)
  end
end

# Przykłady
IO.puts("Tradycyjny sposób - operacja udana: #{inspect(PrzykladyObslugi.tradycyjna_obsluga(:ok))}")
IO.puts("Tradycyjny sposób - operacja z błędem: #{inspect(PrzykladyObslugi.tradycyjna_obsluga(:blad))}")

# Proces z wewnętrzną obsługą błędów
PrzykladyObslugi.proces_z_obsluga_bledow(:blad, self())
receive do
  {:wynik, wynik} -> IO.puts("Proces z obsługą błędów: #{inspect(wynik)}")
after
  1000 -> IO.puts("Brak odpowiedzi od procesu z obsługą")
end

# Proces bez wewnętrznej obsługi błędów - oczekiwanie na komunikat o zakończeniu
{pid, ref} = PrzykladyObslugi.proces_bez_obslugi_bledow(:blad, self())
receive do
  {:wynik, wynik} -> IO.puts("Proces bez obsługi błędów - sukces: #{inspect(wynik)}")
  {:DOWN, ^ref, :process, ^pid, reason} ->
    IO.puts("Proces bez obsługi błędów - zakończony z powodem: #{inspect(reason)}")
after
  1000 -> IO.puts("Brak odpowiedzi od procesu bez obsługi")
end

# ------ Implementacja prostego supervisora ------
IO.puts("\n--- Implementacja prostego supervisora ---")

defmodule ProstySupervisor do
  def start_link(child_spec) do
    pid = spawn_link(fn -> loop(child_spec, nil) end)
    {:ok, pid}
  end

  def loop(child_spec, child_pid) do
    # Uruchomienie procesu potomnego, jeśli jeszcze nie istnieje lub zakończył się
    child_pid = if child_pid == nil or not Process.alive?(child_pid) do
      {m, f, a} = child_spec
      IO.puts("Supervisor: Uruchamianie procesu #{inspect(m)}.#{f}/#{length(a)}")
      apply(m, f, a)
    else
      child_pid
    end

    # Oczekiwanie na wiadomości lub zakończenie procesu potomnego
    receive do
      {:EXIT, ^child_pid, reason} ->
        IO.puts("Supervisor: Proces potomny zakończył się z powodem: #{inspect(reason)}")
        loop(child_spec, nil)

      {:dodaj_dziecko, new_child_spec} ->
        IO.puts("Supervisor: Dodawanie nowego procesu")
        child_pid = apply(elem(new_child_spec, 0), elem(new_child_spec, 1), elem(new_child_spec, 2))
        loop(new_child_spec, child_pid)

      {:stop} ->
        if child_pid != nil and Process.alive?(child_pid) do
          Process.exit(child_pid, :shutdown)
        end
        IO.puts("Supervisor: Zatrzymywanie")
    end
  end
end

# ------ Worker restartowany przez supervisora ------
IO.puts("\n--- Worker restartowany przez supervisora ---")

defmodule PrzykladowyWorker do
  def start_link(nazwa, tryb) do
    pid = spawn_link(fn -> init(nazwa, tryb) end)
    Process.register(pid, :"worker_#{nazwa}")
    pid
  end

  def init(nazwa, tryb) do
    IO.puts("Worker #{nazwa}: Inicjalizacja z trybem #{tryb}")
    przypadkowy_blad = if tryb == :zawodny, do: true, else: false
    loop(nazwa, tryb, przypadkowy_blad, 0)
  end

  def loop(nazwa, tryb, czy_blad, licznik) do
    receive do
      {:wykonaj, operacja, dane} ->
        if czy_blad and :rand.uniform() < 0.5 do
          IO.puts("Worker #{nazwa}: Symulacja błędu przy wykonywaniu #{operacja}")
          raise "Symulowany błąd w operacji #{operacja}"
        else
          IO.puts("Worker #{nazwa}: Wykonywanie operacji #{operacja} na danych #{inspect(dane)}")
          loop(nazwa, tryb, czy_blad, licznik + 1)
        end

      {:status} ->
        IO.puts("Worker #{nazwa}: Status - licznik operacji: #{licznik}")
        loop(nazwa, tryb, czy_blad, licznik)

      {:stop} ->
        IO.puts("Worker #{nazwa}: Zatrzymywanie")
    after
      5000 ->
        if tryb == :zawodny and :rand.uniform() < 0.3 do
          IO.puts("Worker #{nazwa}: Symulacja losowego błędu")
          raise "Losowy błąd w workerze #{nazwa}"
        end
        loop(nazwa, tryb, czy_blad, licznik)
    end
  end

  def wykonaj(nazwa, operacja, dane) do
    send(:"worker_#{nazwa}", {:wykonaj, operacja, dane})
  end

  def status(nazwa) do
    send(:"worker_#{nazwa}", {:status})
  end
end

# Uruchomienie supervisora i workera
{:ok, supervisor} = ProstySupervisor.start_link({PrzykladowyWorker, :start_link, [:worker1, :zawodny]})

# Wykonanie kilku operacji na workerze
:timer.sleep(500)
PrzykladowyWorker.wykonaj(:worker1, :obliczenia, [1, 2, 3])
:timer.sleep(100)
PrzykladowyWorker.status(:worker1)
:timer.sleep(100)

# Wywoływanie operacji, które mogą powodować błędy
for _ <- 1..3 do
  PrzykladowyWorker.wykonaj(:worker1, :ryzykowna_operacja, [:krytyczne_dane])
  :timer.sleep(1000)
  PrzykladowyWorker.status(:worker1)
  :timer.sleep(500)
end

# ------ Korzystanie z OTP Supervisora ------
IO.puts("\n--- Korzystanie z OTP Supervisora ---")

defmodule OTPWorker do
  use GenServer

  # API klienta
  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: via_tuple(arg.nazwa))
  end

  def via_tuple(nazwa) do
    {:via, Registry, {WorkerRegistry, "worker_#{nazwa}"}}
  end

  def wykonaj(nazwa, operacja, dane) do
    GenServer.cast(via_tuple(nazwa), {:wykonaj, operacja, dane})
  end

  def status(nazwa) do
    GenServer.call(via_tuple(nazwa), :status)
  end

  # Callbacks
  @impl true
  def init(arg) do
    IO.puts("OTPWorker #{arg.nazwa}: Inicjalizacja z trybem #{arg.tryb}")
    stan = %{
      nazwa: arg.nazwa,
      tryb: arg.tryb,
      licznik: 0,
      przypadkowy_blad: arg.tryb == :zawodny
    }

    # Ustawiamy timer, który może powodować losowe błędy
    if stan.tryb == :zawodny do
      Process.send_after(self(), :sprawdz_losowy_blad, 5000)
    end

    {:ok, stan}
  end

  @impl true
  def handle_cast({:wykonaj, operacja, dane}, stan) do
    if stan.przypadkowy_blad and :rand.uniform() < 0.5 do
      IO.puts("OTPWorker #{stan.nazwa}: Symulacja błędu przy wykonywaniu #{operacja}")
      raise "Symulowany błąd w operacji #{operacja}"
    else
      IO.puts("OTPWorker #{stan.nazwa}: Wykonywanie operacji #{operacja} na danych #{inspect(dane)}")
      {:noreply, %{stan | licznik: stan.licznik + 1}}
    end
  end

  @impl true
  def handle_call(:status, _from, stan) do
    IO.puts("OTPWorker #{stan.nazwa}: Status - licznik operacji: #{stan.licznik}")
    {:reply, {:ok, stan.licznik}, stan}
  end

  @impl true
  def handle_info(:sprawdz_losowy_blad, stan) do
    if :rand.uniform() < 0.3 do
      IO.puts("OTPWorker #{stan.nazwa}: Symulacja losowego błędu")
      raise "Losowy błąd w OTPWorkerze #{stan.nazwa}"
    end

    Process.send_after(self(), :sprawdz_losowy_blad, 5000)
    {:noreply, stan}
  end

  @impl true
  def terminate(reason, stan) do
    IO.puts("OTPWorker #{stan.nazwa}: Zatrzymywanie z powodem: #{inspect(reason)}")
    :ok
  end
end

defmodule OTPSupervisorApp do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      # Uruchamiamy Registry do identyfikacji procesów
      {Registry, keys: :unique, name: WorkerRegistry},

      # Worker 1 - stabilny
      %{
        id: :worker_stabilny,
        start: {OTPWorker, :start_link, [%{nazwa: :stabilny, tryb: :stabilny}]}
      },

      # Worker 2 - zawodny
      %{
        id: :worker_zawodny,
        start: {OTPWorker, :start_link, [%{nazwa: :zawodny, tryb: :zawodny}]}
      }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

# Uruchomienie OTP supervisora
{:ok, otp_sup} = OTPSupervisorApp.start_link([])
:timer.sleep(500)

# Wykonanie operacji na stabilnym workerze
OTPWorker.wykonaj(:stabilny, :bezpieczna_operacja, [1, 2, 3])
:timer.sleep(100)
OTPWorker.status(:stabilny)

# Wykonanie operacji na zawodnym workerze
for _ <- 1..3 do
  OTPWorker.wykonaj(:zawodny, :ryzykowna_operacja, [:krytyczne_dane])
  :timer.sleep(300)
  try do
    OTPWorker.status(:zawodny)
  catch
    :exit, _ -> IO.puts("Nie można połączyć się z workerem - prawdopodobnie w trakcie restartu")
  end
  :timer.sleep(300)
end

# ------ Różne strategie supervisora ------
IO.puts("\n--- Różne strategie supervisora ---")

IO.puts("""
Dostępne strategie supervisora:

1. :one_for_one - Jeśli proces potomny zakończy się, tylko on jest restartowany.
   Najlepsze dla niezależnych procesów.

2. :one_for_all - Jeśli jeden proces potomny zakończy się, wszystkie są restartowane.
   Dobre, gdy wszystkie procesy są od siebie zależne.

3. :rest_for_one - Jeśli proces potomny zakończy się, ten proces oraz wszystkie procesy
   zdefiniowane po nim są restartowane. Dobre dla zależności liniowych.

4. :simple_one_for_one - Wariant :one_for_one, gdzie wszystkie procesy potomne są
   dynamiczne i tworzone z tej samej specyfikacji. Zastąpione przez DynamicSupervisor.
""")

# ------ Obsługa tymczasowych błędów ------
IO.puts("\n--- Obsługa tymczasowych błędów ---")

defmodule WorkerZRetry do
  use GenServer

  # API klienta
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def wykonaj_operacje(operacja, parametry) do
    GenServer.call(__MODULE__, {:wykonaj, operacja, parametry})
  end

  # Callbacks
  @impl true
  def init(opts) do
    {:ok, %{proby: Map.get(opts, :max_proby, 3)}}
  end

  @impl true
  def handle_call({:wykonaj, operacja, parametry}, from, stan) do
    # Uruchamiamy operację w osobnym procesie, aby nie blokować GenServera
    Task.start(fn ->
      wynik = sprobuj_wykonac(operacja, parametry, stan.proby)
      GenServer.reply(from, wynik)
    end)

    {:noreply, stan}
  end

  # Funkcja z mechanizmem retry
  defp sprobuj_wykonac(operacja, parametry, pozostale_proby, proba \\ 1) do
    try do
      # Symulujemy operację, która może się nie powieść
      if operacja == :zawodna and :rand.uniform() < 0.7 and proba <= pozostale_proby do
        IO.puts("Próba #{proba}/#{pozostale_proby}: Operacja nieudana")
        raise "Tymczasowy błąd operacji"
      end

      IO.puts("Próba #{proba}/#{pozostale_proby}: Operacja zakończona sukcesem")
      {:ok, "Wynik operacji: #{inspect(parametry)}"}
    rescue
      e ->
        if proba < pozostale_proby do
          # Wykładniczy backoff - zwiększanie czasu oczekiwania między próbami
          czas_oczekiwania = :math.pow(2, proba) * 100 |> round
          IO.puts("Oczekiwanie #{czas_oczekiwania}ms przed ponowną próbą...")
          :timer.sleep(czas_oczekiwania)

          # Rekurencyjne wywołanie z inkrementacją licznika prób
          sprobuj_wykonac(operacja, parametry, pozostale_proby, proba + 1)
        else
          IO.puts("Wszystkie próby nieudane. Operacja zakończona błędem.")
          {:error, "Wyczerpano limit prób (#{pozostale_proby}): #{Exception.message(e)}"}
        end
    end
  end
end

# Uruchamiamy workera z mechanizmem retry
{:ok, _worker} = WorkerZRetry.start_link(%{max_proby: 4})

# Wykonujemy operację, która najprawdopodobniej kilka razy się nie powiedzie
IO.puts("\nWykonanie zawodnej operacji z retry:")
wynik = WorkerZRetry.wykonaj_operacje(:zawodna, [1, 2, 3])
IO.puts("Końcowy wynik: #{inspect(wynik)}")

# Wykonujemy operację, która najprawdopodobniej się powiedzie
IO.puts("\nWykonanie niezawodnej operacji:")
wynik = WorkerZRetry.wykonaj_operacje(:niezawodna, [4, 5, 6])
IO.puts("Końcowy wynik: #{inspect(wynik)}")

# ------ Circuit Breaker Pattern ------
IO.puts("\n--- Circuit Breaker Pattern ---")

defmodule CircuitBreaker do
  use GenServer

  # API klienta
  def start_link(opts) do
    nazwa = Keyword.get(opts, :nazwa, __MODULE__)
    GenServer.start_link(__MODULE__, opts, name: nazwa)
  end

  def wykonaj(pid, operacja, args) do
    GenServer.call(pid, {:wykonaj, operacja, args})
  end

  def status(pid) do
    GenServer.call(pid, :status)
  end

  def reset(pid) do
    GenServer.cast(pid, :reset)
  end

  # Callbacks
  @impl true
  def init(opts) do
    stan = %{
      stan_obwodu: :zamkniety,  # :zamkniety, :otwarty, :polotwarty
      bledy_proba: 0,
      calkowite_bledy: 0,
      prog_bledow: Keyword.get(opts, :prog_bledow, 3),
      czas_odnowienia_ms: Keyword.get(opts, :czas_odnowienia_ms, 5000),
      funkcja: Keyword.get(opts, :funkcja)
    }

    {:ok, stan}
  end

  @impl true
  def handle_call({:wykonaj, operacja, args}, _from, %{stan_obwodu: :otwarty} = stan) do
    {:reply, {:error, :circuit_open}, stan}
  end

  @impl true
  def handle_call({:wykonaj, operacja, args}, _from, %{stan_obwodu: :polotwarty} = stan) do
    # W stanie półotwartym pozwalamy na wykonanie próby
    try do
      wynik = apply(stan.funkcja, [operacja, args])
      # Jeśli się powiedzie, zamykamy obwód
      IO.puts("Circuit Breaker: Próba w stanie półotwartym udana, zamykanie obwodu")
      {:reply, {:ok, wynik}, %{stan | stan_obwodu: :zamkniety, bledy_proba: 0}}
    rescue
      e ->
        # Jeśli się nie powiedzie, obwód pozostaje otwarty
        IO.puts("Circuit Breaker: Próba w stanie półotwartym nieudana, obwód pozostaje otwarty")
        nowy_stan = %{
          stan |
          stan_obwodu: :otwarty,
          bledy_proba: 0,
          calkowite_bledy: stan.calkowite_bledy + 1
        }

        # Ustawiamy timer do przejścia w stan półotwarty po czasie odnowienia
        Process.send_after(self(), :przejscie_do_polotwartego, stan.czas_odnowienia_ms)

        {:reply, {:error, Exception.message(e)}, nowy_stan}
    end
  end

  @impl true
  def handle_call({:wykonaj, operacja, args}, _from, %{stan_obwodu: :zamkniety} = stan) do
    try do
      wynik = apply(stan.funkcja, [operacja, args])
      {:reply, {:ok, wynik}, %{stan | bledy_proba: 0}}
    rescue
      e ->
        nowe_bledy = stan.bledy_proba + 1
        nowy_stan = %{stan | bledy_proba: nowe_bledy, calkowite_bledy: stan.calkowite_bledy + 1}

        if nowe_bledy >= stan.prog_bledow do
          IO.puts("Circuit Breaker: Próg błędów osiągnięty (#{nowe_bledy}/#{stan.prog_bledow}), otwieranie obwodu")
          # Ustawiamy timer do przejścia w stan półotwarty po czasie odnowienia
          Process.send_after(self(), :przejscie_do_polotwartego, stan.czas_odnowienia_ms)

          {:reply, {:error, Exception.message(e)}, %{nowy_stan | stan_obwodu: :otwarty, bledy_proba: 0}}
        else
          {:reply, {:error, Exception.message(e)}, nowy_stan}
        end
    end
  end

  @impl true
  def handle_call(:status, _from, stan) do
    {:reply, {stan.stan_obwodu, stan.bledy_proba, stan.calkowite_bledy}, stan}
  end

  @impl true
  def handle_cast(:reset, stan) do
    {:noreply, %{stan | stan_obwodu: :zamkniety, bledy_proba: 0}}
  end

  @impl true
  def handle_info(:przejscie_do_polotwartego, stan) do
    IO.puts("Circuit Breaker: Przejście do stanu półotwartego")
    {:noreply, %{stan | stan_obwodu: :polotwarty}}
  end
end

# Symulacja zawodnej operacji zewnętrznej
defmodule ZawodnaOperacja do
  def wykonaj(typ, args) do
    case typ do
      :zawsze_blad ->
        raise "Symulowany błąd w zawodnej operacji"

      :czasami_blad ->
        if :rand.uniform() < 0.7 do
          raise "Symulowany losowy błąd w zawodnej operacji"
        else
          "Wynik pomyślnej operacji: #{inspect(args)}"
        end

      :zawsze_ok ->
        "Wynik zawsze pomyślnej operacji: #{inspect(args)}"
    end
  end
end

# Uruchamiamy circuit breaker
{:ok, cb} = CircuitBreaker.start_link(
  nazwa: :test_cb,
  prog_bledow: 3,
  czas_odnowienia_ms: 2000,
  funkcja: &ZawodnaOperacja.wykonaj/2
)

# Testowanie circuit breakera z operacją, która czasami się nie udaje
IO.puts("\nTestowanie circuit breakera:")

for i <- 1..10 do
  wynik = CircuitBreaker.wykonaj(cb, :czasami_blad, ["próba #{i}"])
  {stan, bledy_proba, calkowite_bledy} = CircuitBreaker.status(cb)
  IO.puts("Próba #{i}: Wynik=#{inspect(wynik)}, Stan=#{stan}, Błędy próba=#{bledy_proba}, Całkowite błędy=#{calkowite_bledy}")
  :timer.sleep(700)
end

IO.puts("\nTo podsumowuje wykorzystanie supervisorów do obsługi błędów w procesach!")
