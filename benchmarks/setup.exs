Application.ensure_all_started(:pagex)

{:ok, _} = Benchmark.Repo.start_link()

# Ensure DB exists
case Ecto.Adapters.Postgres.storage_up(Benchmark.Repo.config()) do
  :ok -> IO.puts("Database created")
  {:error, :already_up} -> IO.puts("Database already exists")
  {:error, reason} -> raise "Could not create database: #{inspect(reason)}"
end

# Create table
Benchmark.Repo.query!("""
  CREATE TABLE IF NOT EXISTS posts (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255),
    inserted_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
  )
""")

IO.puts("Table created, seeding 100_000 rows...")

Enum.each(1..100_000, fn i ->
  Benchmark.Repo.insert!(struct(Benchmark.Post, %{title: "Post #{i}"}))
end)

IO.puts("Done!")
