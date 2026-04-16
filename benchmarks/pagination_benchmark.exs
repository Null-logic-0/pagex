# Ensure application is fully started (Repo, configs, ecto, etc.)
{:ok, _} = Application.ensure_all_started(:pagex)

# Start benchmark repo safely (avoid crash if already started)
{:ok, _} = Benchmark.Repo.start_link()

alias Benchmark.Repo
alias Benchmark.Post

Benchee.run(
  %{
    "offset page 1 (with count)" => fn ->
      Pagex.paginate(Post, %{"page" => "1"}, Repo)
    end,
    "offset page 100 (with count)" => fn ->
      Pagex.paginate(Post, %{"page" => "100"}, Repo)
    end,
    "offset page 1 (no count)" => fn ->
      Pagex.paginate(Post, %{"page" => "1"}, Repo, count: false)
    end,
    "offset page 100 (no count)" => fn ->
      Pagex.paginate(Post, %{"page" => "100"}, Repo, count: false)
    end,
    "cursor first page" => fn ->
      Pagex.paginate_cursor(Post, %{}, Repo)
    end,
    "cursor next page chain" => fn ->
      {_items, meta} = Pagex.paginate_cursor(Post, %{}, Repo)
      Pagex.paginate_cursor(Post, %{"after" => meta.next_cursor}, Repo)
    end
  },
  time: 5,
  memory_time: 2
)
