defmodule RestApi.Router do
  @moduledoc """
  Router dla REST API - obsługuje routing żądań HTTP.
  """

  use Plug.Router

  alias RestApi.DataStore

  # Plugi są wywoływane w kolejności deklaracji
  plug Plug.Logger                            # Logowanie żądań HTTP
  plug :match                                 # Dopasowanie żądań do ścieżek
  plug Plug.Parsers,                          # Parsowanie body
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  plug :dispatch                              # Obsługa żądania przez funkcję

  # Startuje DataStore (Agent) z przykładowymi danymi
  def init(options) do
    DataStore.start_link([])
    options
  end

  # Obsługa GET na ścieżce głównej
  get "/" do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, """
    <!DOCTYPE html>
    <html>
    <head>
      <title>REST API w Elixir</title>
      <style>
        body { font-family: Arial, sans-serif; margin: 2em; line-height: 1.5; }
        h1 { color: #4b0082; }
        .endpoint { margin-bottom: 1em; }
        code { background-color: #f5f5f5; padding: 0.2em; }
      </style>
    </head>
    <body>
      <h1>REST API w Elixir</h1>
      <p>Przykładowe API zbudowane przy użyciu Elixir i Plug.</p>

      <h2>Dostępne endpointy:</h2>

      <div class="endpoint">
        <code>GET /api/users</code> - Lista wszystkich użytkowników
      </div>

      <div class="endpoint">
        <code>GET /api/users/:id</code> - Szczegóły pojedynczego użytkownika
      </div>

      <div class="endpoint">
        <code>POST /api/users</code> - Dodanie nowego użytkownika
      </div>

      <div class="endpoint">
        <code>PUT /api/users/:id</code> - Aktualizacja użytkownika
      </div>

      <div class="endpoint">
        <code>DELETE /api/users/:id</code> - Usunięcie użytkownika
      </div>
    </body>
    </html>
    """)
  end

  # Obsługa GET dla /api/users
  get "/api/users" do
    users = DataStore.get_users()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{data: users}))
  end

  # Obsługa GET dla /api/users/:id
  get "/api/users/:id" do
    case DataStore.get_user(id) do
      nil ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, Jason.encode!(%{error: "Użytkownik nie znaleziony"}))

      user ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(%{data: user}))
    end
  end

  # Obsługa POST dla /api/users
  post "/api/users" do
    {status, body} =
      case conn.body_params do
        %{"name" => _name} = user_params ->
          # Konwersja kluczy na atomy
          user_params = for {key, val} <- user_params, into: %{}, do: {String.to_atom(key), val}
          user = DataStore.create_user(user_params)
          {201, %{message: "Użytkownik dodany", data: user}}

        _ ->
          {422, %{error: "Nieprawidłowe dane użytkownika"}}
      end

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(body))
  end

  # Obsługa PUT dla /api/users/:id
  put "/api/users/:id" do
    {status, body} =
      case conn.body_params do
        %{} = user_params when map_size(user_params) > 0 ->
          # Konwersja kluczy na atomy
          user_params = for {key, val} <- user_params, into: %{}, do: {String.to_atom(key), val}

          case DataStore.update_user(id, user_params) do
            nil ->
              {404, %{error: "Użytkownik nie znaleziony"}}

            user ->
              {200, %{message: "Użytkownik zaktualizowany", data: user}}
          end

        _ ->
          {422, %{error: "Nieprawidłowe dane użytkownika"}}
      end

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(body))
  end

  # Obsługa DELETE dla /api/users/:id
  delete "/api/users/:id" do
    case DataStore.get_user(id) do
      nil ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, Jason.encode!(%{error: "Użytkownik nie znaleziony"}))

      _ ->
        DataStore.delete_user(id)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(%{message: "Użytkownik usunięty"}))
    end
  end

  # Domyślna obsługa dla niedopasowanych ścieżek
  match _ do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, Jason.encode!(%{error: "Nie znaleziono"}))
  end
end
