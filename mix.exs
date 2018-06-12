defmodule Duo.MixProject do
  use Mix.Project

  def project do
    [
      app: :duo_client,
      description: "Duo Authentication Api Client",
      version: "0.0.1-beta.2",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: applications(Mix.env())
    ]
  end

  defp applications(:dev), do: applications(:all) ++ [:remix]
  defp applications(_all), do: [:logger]

  defp package do
    [
      maintainers: ["chevinbrown"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/chevinbrown/duo_client_elixir"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:jason, ">= 1.0.0"},
      {:remix, "~> 0.0.1", only: :dev},
      {:tesla, "1.0.0"}
    ]
  end
end
