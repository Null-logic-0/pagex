defmodule Benchmark.Repo do
  use Ecto.Repo,
    otp_app: :pagex,
    adapter: Ecto.Adapters.Postgres
end
