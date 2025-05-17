defmodule RestApi.Application do
  @moduledoc """
  Główny moduł aplikacji REST API.
  """

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      # Uruchamia serwer Cowboy z Plug pod adresem 0.0.0.0:4000
      {Plug.Cowboy, scheme: :http, plug: RestApi.Router, options: [port: 4000]}
    ]

    opts = [strategy: :one_for_one, name: RestApi.Supervisor]

    Logger.info("Uruchamianie serwera REST API na http://localhost:4000")

    Supervisor.start_link(children, opts)
  end
end

defmodule RestApi.DataStore do
  @moduledoc """
  Prosty in-memory store dla danych użytkowników.
  W prawdziwej aplikacji byłaby to baza danych.
  """

  use Agent

  # Funkcja startowa agenta z przykładowymi danymi
  def start_link(_opts) do
    Agent.start_link(fn -> initial_data() end, name: __MODULE__)
  end

  # Pobranie wszystkich użytkowników
  def get_users do
    Agent.get(__MODULE__, & &1)
  end

  # Pobranie konkretnego użytkownika
  def get_user(id) do
    id = String.to_integer(id)
    Agent.get(__MODULE__, fn users ->
      Enum.find(users, &(&1.id == id))
    end)
  end

  # Dodanie nowego użytkownika
  def create_user(user) do
    Agent.update(__MODULE__, fn users ->
      id = (users |> Enum.map(& &1.id) |> Enum.max(fn -> 0 end)) + 1
      user = Map.put(user, :id, id)
      users ++ [user]
    end)

    # Zwrócenie id
    get_users() |> List.last()
  end

  # Aktualizacja użytkownika
  def update_user(id, user_params) do
    id = String.to_integer(id)
    Agent.update(__MODULE__, fn users ->
      user_index = Enum.find_index(users, &(&1.id == id))

      if user_index do
        user = Enum.at(users, user_index)
        updated_user = Map.merge(user, user_params)
        List.replace_at(users, user_index, updated_user)
      else
        users
      end
    end)

    get_user(id)
  end

  # Usunięcie użytkownika
  def delete_user(id) do
    id = String.to_integer(id)
    Agent.update(__MODULE__, fn users ->
      Enum.filter(users, &(&1.id != id))
    end)
    :ok
  end

  # Przykładowe dane początkowe
  defp initial_data do
    [
      %{id: 1, name: "Jan Kowalski", email: "jan@example.com"},
      %{id: 2, name: "Anna Nowak", email: "anna@example.com"},
      %{id: 3, name: "Piotr Wiśniewski", email: "piotr@example.com"}
    ]
  end
end
