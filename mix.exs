defmodule Pagex.MixProject do
  use Mix.Project

  @version "0.2.3"
  @source_url "https://github.com/Null-logic-0/pagex"

  def project do
    [
      app: :pagex_pagination,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      description: description(),
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ecto, "~> 3.10 or ~> 3.11"},
      {:ecto_sql, "~> 3.11"},
      {:postgrex, "~> 0.19"},
      {:phoenix_html, "~> 4.0", optional: true},
      {:phoenix_live_view, "~> 1.0", optional: true},
      {:jason, "~> 1.4", optional: true},

      # Dev only
      {:ex_doc, "~> 0.30", only: :dev, runtime: false},
      {:benchee, "~> 1.3", only: :dev},

      # Test only
      {:mox, "~> 1.0", only: :test}
    ]
  end

  defp description do
    "Fast, minimal pagination for Ecto and Phoenix. Supports offset and cursor pagination with LiveView support."
  end

  defp package do
    [
      name: "pagex_pagination",
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url},
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE CHANGELOG.md)
    ]
  end

  defp docs do
    [
      main: "Pagex",
      source_url: @source_url,
      extras: ["README.md", "CHANGELOG.md"]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(:dev), do: ["lib", "benchmarks/support"]
  defp elixirc_paths(_), do: ["lib"]
end
