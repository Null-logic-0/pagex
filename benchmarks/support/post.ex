defmodule Benchmark.Post do
  @moduledoc """
    Ecto schema used for benchmarking Pagex pagination performance.

    This schema represents a minimal `posts` table used in performance
    tests, load benchmarks, and pagination comparisons between offset
    and cursor strategies.

    It is intentionally minimal to avoid noise in benchmark results.
  """

  use Ecto.Schema

  @doc """
    Benchmark post schema.

    Represents a simple record used to simulate realistic pagination
    workloads in benchmarks.

    Fields:
      - `title` - post title (string)
      - `inserted_at` / `updated_at` - timestamps
  """
  schema "posts" do
    field(:title, :string)
    timestamps()
  end
end
