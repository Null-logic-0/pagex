defmodule Pagex.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/Null-logic-0/pagex"

  def project do
    [
      app: :pagex,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
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
      {:phoenix_html, "~> 3.3 or ~> 4.0", optional: true},
      {:phoenix_live_view, "~> 0.18 or ~> 0.20", optional: true},
      {:jason, "~> 1.4", optional: true},

      # Dev only
      {:ex_doc, "~> 0.30", only: :dev, runtime: false},
      {:benchee, "~> 1.3", only: :dev}
    ]
  end

  defp description do
    "Fast, minimal pagination for Ecto and Phoenix. Supports offset and cursor pagination with LiveView support."
  end

  defp package do
    [
      name: "pagex",
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
end
