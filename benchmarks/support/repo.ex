defmodule Benchmark.Repo do
  @moduledoc """
  Ecto repository used exclusively for benchmarking Pagex.

  This Repo is configured for performance testing and is not intended
  for production use.

  It provides database access for benchmark datasets used to compare
  offset and cursor pagination strategies under realistic load.
  """
  use Ecto.Repo,
    otp_app: :pagex,
    adapter: Ecto.Adapters.Postgres
end
