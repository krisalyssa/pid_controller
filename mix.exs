defmodule PidController.MixProject do
  @moduledoc false

  use Mix.Project

  def project do
    [
      app: :pid_controller,
      version: "0.1.0",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      elixirc_options: [warnings_as_errors: true],
      start_permanent: Mix.env() == :prod,
      preferred_cli_env: [espec: :test],
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {PidController.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp aliases do
    [
      credo: ["credo --strict"],
      test: ["espec"]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.0"},
      {:dialyxir, "~> 1.0.0-rc.3", only: [:dev], runtime: false},
      {:espec, "~> 1.6", only: :test},
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "spec/support"]
  defp elixirc_paths(_), do: ["lib"]
end
