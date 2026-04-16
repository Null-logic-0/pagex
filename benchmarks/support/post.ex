defmodule Benchmark.Post do
  use Ecto.Schema

  schema "posts" do
    field :title, :string
    timestamps()
  end
end
