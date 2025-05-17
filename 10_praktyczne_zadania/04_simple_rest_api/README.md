# Prosty serwer REST API w Elixir

Ten przykład pokazuje jak stworzyć prosty serwer REST API w Elixir przy użyciu biblioteki Plug.

## Struktura projektu

Projekt składa się z następujących plików:
- `mix.exs` - konfiguracja projektu i zależności
- `lib/rest_api.ex` - główny moduł aplikacji
- `lib/router.ex` - router obsługujący ścieżki API

## Instalacja

1. Utwórz projekt Mix:

```bash
mix new rest_api --sup
cd rest_api
```

2. Dodaj zależności w pliku `mix.exs`:

```elixir
defp deps do
  [
    {:plug_cowboy, "~> 2.5"},
    {:jason, "~> 1.2"}
  ]
end
```

3. Zainstaluj zależności:

```bash
mix deps.get
```

4. Skopiuj kod z plików `lib/rest_api.ex` i `lib/router.ex` do odpowiadających im plików w projekcie.

## Uruchomienie

Uruchom serwer z konsoli:

```bash
mix run --no-halt
```

lub w trybie interaktywnej konsoli IEx:

```bash
iex -S mix
```

Serwer będzie dostępny pod adresem: http://localhost:4000

## Testowanie API

Możesz przetestować API używając narzędzia curl:

```bash
# Pobranie wszystkich użytkowników
curl -X GET http://localhost:4000/api/users

# Pobranie konkretnego użytkownika
curl -X GET http://localhost:4000/api/users/1

# Dodanie nowego użytkownika
curl -X POST http://localhost:4000/api/users -H "Content-Type: application/json" -d '{"name": "Nowy Użytkownik", "email": "nowy@example.com"}'

# Aktualizacja użytkownika
curl -X PUT http://localhost:4000/api/users/1 -H "Content-Type: application/json" -d '{"name": "Zaktualizowany Użytkownik"}'

# Usunięcie użytkownika
curl -X DELETE http://localhost:4000/api/users/1
```

## Endpointy API

- `GET /api/users` - pobierz listę użytkowników
- `GET /api/users/:id` - pobierz konkretnego użytkownika
- `POST /api/users` - dodaj nowego użytkownika
- `PUT /api/users/:id` - aktualizuj użytkownika
- `DELETE /api/users/:id` - usuń użytkownika

## Rozszerzenie

Ten przykład można rozbudować o:
- Walidację danych wejściowych
- Obsługę błędów
- Persistencję danych (baza danych)
- Autoryzację i uwierzytelnianie
- Dokumentację API (Swagger/OpenAPI) 