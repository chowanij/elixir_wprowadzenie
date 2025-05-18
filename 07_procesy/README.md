# Procesy w Elixir

Elixir oparty jest na maszynie wirtualnej BEAM (Erlang VM), która zapewnia lekkie procesy, system komunikacji między procesami oraz mechanizmy nadzoru. Procesy w Elixir są fundamentem współbieżności i odporności na błędy.

## Zawartość sekcji

- **podstawy_procesow.exs** - Podstawowe operacje na procesach (spawn, send, receive)
- **komunikacja_procesow.exs** - Wzorce komunikacji między procesami
- **process_registry.exs** - Rejestracja i nazywanie procesów
- **genserver.exs** - Implementacja zachowania GenServer
- **supervisory.exs** - Drzewa nadzoru i strategie nadzoru
- **zadania.exs** - Moduł Task

## Dobre praktyki

1. **Długość życia procesów** - Twórz procesy odpowiednie do wykonywanych zadań. Krótkie procesy do prostych obliczeń, długotrwałe dla stanu i usług.

2. **Izolacja błędów** - Wykorzystuj "Let it crash" - pozwól procesom umierać i pozwól supervisorom je restartować.

3. **Komunikacja asynchroniczna** - Preferuj komunikację asynchroniczną (cast) nad synchroniczną (call), gdy to możliwe.

4. **Monitorowanie i łączenie** - Używaj `Process.monitor/1` zamiast `Process.link/1` do obserwowania procesów, z którymi nie jesteś bezpośrednio powiązany.

5. **Nadzór** - Grupuj procesy w sposób logiczny pod odpowiednimi supervisorami z odpowiednimi strategiami restartu.

6. **Stan** - Przekazuj stan jako parametr w funkcjach rekurencyjnych zamiast używać zmiennych globalnych. 