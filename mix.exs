defmodule PidController.MixProject do
  use Mix.Project

  def project do
    [
      app: :pid_controller,
      version: "0.1.0",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {PidController.Application, []}
    ]
  end

  defp aliases do
    [
    ]
  end

  defp deps do
    [
    ]
  end

  defp elixirc_paths(:test), do: ["lib"]
  defp elixirc_paths(_), do: ["lib"]
end
