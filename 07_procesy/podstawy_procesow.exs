# Podstawy procesów w Elixir

IO.puts("=== Podstawy procesów w Elixir ===\n")

# ------ Tworzenie procesów ------
IO.puts("--- Tworzenie procesów ---")

# Funkcja spawn tworzy nowy proces i zwraca PID (Process Identifier)
pid = spawn(fn ->
  IO.puts("Witaj z nowego procesu!")
end)

IO.puts("PID nowego procesu: #{inspect(pid)}")
IO.puts("Typ PID: #{inspect(pid.__struct__)}")

# Możemy także użyć spawn z modułem, nazwą funkcji i argumentami
defmodule Powitanie do
  def powitaj(imie) do
    IO.puts("Witaj, #{imie}, z procesu #{inspect(self())}!")
  end
end

spawn(Powitanie, :powitaj, ["Anna"])

# Procesy w Elixir są lekkie (lightweight)
IO.puts("\n--- Tworzenie wielu procesów ---")

start_time = System.monotonic_time(:millisecond)
for _ <- 1..10_000 do
  spawn(fn -> nil end)
end
end_time = System.monotonic_time(:millisecond)

IO.puts("Czas utworzenia 10 000 procesów: #{end_time - start_time} ms")

# ------ Komunikacja między procesami ------
IO.puts("\n--- Podstawowa komunikacja między procesami ---")

# Proces może wysłać wiadomość do innego procesu za pomocą send
child_pid = spawn(fn ->
  # Proces oczekuje na wiadomości używając receive
  receive do
    {:hello, msg} -> IO.puts("Otrzymano wiadomość: #{msg}")
    _ -> IO.puts("Otrzymano nieoczekiwaną wiadomość")
  end
end)

# Wysłanie wiadomości do procesu
send(child_pid, {:hello, "Witaj z procesu rodzica!"})

# Dajmy czas na przetworzenie wiadomości
:timer.sleep(100)

# ------ Timeout w receive ------
IO.puts("\n--- Timeout w receive ---")

pid = spawn(fn ->
  receive do
    msg -> IO.puts("Otrzymano wiadomość: #{inspect(msg)}")
  after
    # Timeout po 1000 ms (1 s)
    1000 -> IO.puts("Nie otrzymano wiadomości w ciągu 1 sekundy")
  end
end)

IO.puts("Czekamy na timeout...")
:timer.sleep(1100)

# ------ Procesy z cyklami życia ------
IO.puts("\n--- Procesy z dłuższym cyklem życia ---")

defmodule CyklicznyProces do
  def start do
    spawn(fn -> petla(0) end)
  end

  def petla(stan) do
    # Oczekiwanie na wiadomość
    receive do
      {:pobierz, pid} ->
        send(pid, {:stan, stan})
        petla(stan)
      {:inkrementuj} ->
        IO.puts("Zwiększono stan do #{stan + 1}")
        petla(stan + 1)
      {:zatrzymaj} ->
        IO.puts("Zatrzymuję proces")
        # Nie wywołujemy petla/1, więc proces kończy działanie
    end
  end
end

# Uruchamiamy proces z cyklem życia
licznik_pid = CyklicznyProces.start()

# Komunikujemy się z procesem
send(licznik_pid, {:inkrementuj})
:timer.sleep(100)

send(licznik_pid, {:inkrementuj})
:timer.sleep(100)

send(licznik_pid, {:pobierz, self()})

# Odbieramy stan
receive do
  {:stan, stan} -> IO.puts("Aktualny stan: #{stan}")
after
  1000 -> IO.puts("Nie otrzymano stanu")
end

# Zatrzymujemy proces
send(licznik_pid, {:zatrzymaj})
:timer.sleep(100)

# ------ Process.alive? ------
IO.puts("\n--- Sprawdzanie czy proces żyje ---")

pid1 = spawn(fn -> :timer.sleep(5000) end)
pid2 = spawn(fn -> :timer.sleep(10) end)

IO.puts("Proces 1 żyje? #{Process.alive?(pid1)}")
IO.puts("Proces 2 żyje? #{Process.alive?(pid2)}")

:timer.sleep(100)

IO.puts("Po odczekaniu 100ms:")
IO.puts("Proces 1 żyje? #{Process.alive?(pid1)}")
IO.puts("Proces 2 żyje? #{Process.alive?(pid2)}")

# ------ Process.exit ------
IO.puts("\n--- Zakończenie procesu ---")

pid = spawn(fn ->
  receive do
    :ok -> IO.puts("Otrzymano :ok")
  end
end)

IO.puts("Proces żyje? #{Process.alive?(pid)}")

# Kończymy proces
Process.exit(pid, :kill)
:timer.sleep(100)

IO.puts("Proces żyje po wywołaniu exit? #{Process.alive?(pid)}")

# ------ Linkowanie procesów ------
IO.puts("\n--- Linkowanie procesów ---")

# Gdy proces kończy się z błędem, powiązane procesy również kończą działanie
defmodule LinkowanieProcesu do
  def start do
    spawn(fn ->
      IO.puts("Proces rodzic startuje")
      # Link powoduje, że gdy proces potomny kończy się błędem,
      # proces rodzic również się kończy
      spawn_link(fn ->
        IO.puts("Proces potomny startuje")
        :timer.sleep(500)
        # Symulowanie błędu
        raise "Błąd w procesie potomnym!"
      end)

      # Czekamy na błąd lub wiadomość
      receive do
        msg -> IO.puts("Otrzymano: #{inspect(msg)}")
      end
    end)
  end
end

IO.puts("Uruchamianie procesu z linkowaniem...")

pid = LinkowanieProcesu.start()
:timer.sleep(1000)

# Próba sprawdzenia, czy proces nadal działa (nie powinien)
IO.puts("Proces rodzic nadal żyje? #{Process.alive?(pid)}")

# ------ Process.flag/2 z trap_exit ------
IO.puts("\n--- Przechwytywanie sygnałów zakończenia ---")

defmodule PrzechwytywanieWyjsc do
  def start do
    spawn(fn ->
      # Ustawienie flagi trap_exit na true
      Process.flag(:trap_exit, true)
      IO.puts("Proces rodzic startuje z trap_exit=true")

      child = spawn_link(fn ->
        IO.puts("Proces potomny startuje")
        :timer.sleep(500)
        # Symulowanie błędu
        exit(:powod_wyjscia)
      end)

      IO.puts("PID procesu potomnego: #{inspect(child)}")

      # Oczekiwanie na sygnał EXIT
      receive do
        {:EXIT, from, reason} ->
          IO.puts("Otrzymano sygnał EXIT od #{inspect(from)} z powodem: #{inspect(reason)}")
      end
    end)
  end
end

pid = PrzechwytywanieWyjsc.start()
:timer.sleep(1000)

# ------ Process.monitor ------
IO.puts("\n--- Monitorowanie procesów ---")

defmodule MonitorowanieProcesu do
  def start do
    spawn(fn ->
      IO.puts("Proces monitorujący startuje")

      # Tworzymy proces do monitorowania
      child = spawn(fn ->
        IO.puts("Monitorowany proces startuje")
        :timer.sleep(500)
        # Symulowanie zakończenia
        exit(:normalnie)
      end)

      # Monitorowanie procesu
      ref = Process.monitor(child)
      IO.puts("Monitorowanie uruchomione, ref: #{inspect(ref)}")

      # Oczekiwanie na wiadomość o zakończeniu
      receive do
        {:DOWN, ^ref, :process, pid, reason} ->
          IO.puts("Proces #{inspect(pid)} zakończony z powodem: #{inspect(reason)}")
      end
    end)
  end
end

MonitorowanieProcesu.start()
:timer.sleep(1000)

# ------ Process Dictionary ------
IO.puts("\n--- Słownik procesu ---")

# Każdy proces ma własny słownik do przechowywania danych
# Uwaga: Używanie słownika procesu nie jest zalecane w kodzie produkcyjnym
# Jest to mechanizm mutowalnego stanu, który narusza zasady funkcyjności

defmodule SlownikProcesu do
  def demo do
    # Ustawienie wartości w słowniku procesu
    Process.put(:klucz, "wartość")
    Process.put(:licznik, 42)

    # Odczytanie wartości
    klucz = Process.get(:klucz)
    licznik = Process.get(:licznik)

    IO.puts("Wartości w słowniku procesu:")
    IO.puts("klucz: #{klucz}")
    IO.puts("licznik: #{licznik}")

    # Usunięcie wartości i zwrócenie usuniętej wartości
    stara_wartosc = Process.delete(:klucz)
    IO.puts("Usunięto klucz, wartość była: #{stara_wartosc}")

    # Wszystkie wartości w słowniku
    IO.puts("Cały słownik: #{inspect(Process.get())}")
  end
end

SlownikProcesu.demo()

IO.puts("\nTo podsumowuje podstawy procesów w Elixir!")
