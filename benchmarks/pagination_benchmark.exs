Benchee.run(%{

  # OFFSET PAGINATION

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

  # CURSOR PAGINATION

  "cursor first page" => fn ->
    Pagex.paginate_cursor(Post, %{}, Repo)
  end,

  "cursor next page chain" => fn ->
    {items, _meta} = Pagex.paginate_cursor(Post, %{}, Repo)
    last = List.last(items)

    cursor = Pagex.Cursor.encode_cursor(last)

    Pagex.paginate_cursor(Post, %{"after" => cursor}, Repo)
  end
},
time: 5,
memory_time: 2)
