defmodule RestApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :rest_api,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Konfiguracja aplikacji
  def application do
    [
      extra_applications: [:logger],
      mod: {RestApi.Application, []}
    ]
  end

  # Zależności
  defp deps do
    [
      {:plug_cowboy, "~> 2.5"},  # Plug adapter dla serwera HTTP Cowboy
      {:jason, "~> 1.2"}         # Biblioteka do parsowania/generowania JSON
    ]
  end
end
