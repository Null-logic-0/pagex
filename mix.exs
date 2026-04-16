defmodule Pagex.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/yourusername/fast_paginate"

  def project do
    [
      app: :pagex,
      version: @version,
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.11"},
      {:phoenix_html, "~> 4.0", optional: true},
      {:phoenix_live_view, "~> 0.20", optional: true},
      {:jason, "~> 1.4", optional: true},
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
