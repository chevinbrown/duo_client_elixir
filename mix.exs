defmodule Duo.MixProject do
  use Mix.Project

  def project do
    [
      app: :duo_client,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: applications(Mix.env())
    ]
  end

  defp applications(:dev), do: applications(:all) ++ [:remix]
  defp applications(_all), do: [:logger, :httpoison, :timex]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.1.1"},
      {:remix, "~> 0.0.1", only: :dev},
      {:timex, "~> 3.1"}
    ]
  end
end
