defmodule Pagex do
  @moduledoc """
  Pagex is a lightweight, fast pagination library for Ecto and Phoenix applications.

  It provides two pagination strategies:

  - **Offset pagination** (traditional page/page_size)
  - **Cursor pagination** (keyset-based, scalable for large datasets)

  Pagex is designed with a minimal and explicit API:
  - No macros
  - No global configuration
  - Pure functions that return `{items, meta}` tuples
  - Safe defaults with predictable behavior

  ## Features

  - Offset pagination with optional total count
  - Cursor-based pagination for large datasets
  - Ecto-friendly query handling
  - Phoenix LiveView compatible
  - JSON/API-friendly metadata output

  ## Example (Offset pagination)

      {posts, meta} =
        Pagex.paginate(Post, %{"page" => "1", "page_size" => "20"}, Repo)

  ## Example (Cursor pagination)

      {posts, meta} =
        Pagex.paginate_cursor(Post, %{"after" => cursor}, Repo)

  ## Return format

  All functions return:

      {items, meta}

  where `meta` contains pagination state such as page info or cursors.
  """

  alias Pagex.{Cursor, Offset}

  @doc """
  Runs offset-based pagination on an Ecto query.

    ## Parameters

      - `query` - An `Ecto.Queryable` (schema or query)
      - `params` - Map of pagination params (`"page"`, `"page_size"`)
      - `repo` - The Ecto repository module
      - `opts` - Optional configuration:
        - `:count` (boolean, default: true) — whether to run total count query
        - `:default_page`
        - `:default_page_size`
        - `:max_page_size`

    ## Returns

        {items, meta}

    where:
      - `items` is the list of results for the current page
      - `meta` contains pagination metadata (page, page_size, total, etc.)

    ## Example

        Pagex.paginate(Post, %{"page" => "2"}, Repo)
  """
  def paginate(query, params, repo, opts \\ []) do
    Offset.paginate(query, params, repo, opts)
  end

  @doc """
  Runs cursor-based pagination on an Ecto query.

    Cursor pagination is more efficient for large datasets because it avoids
    expensive `OFFSET` operations and scales better with deep paging.

    ## Parameters

      - `query` - An `Ecto.Queryable`
      - `params` - Map containing `"after"` or `"before"` cursor values
      - `repo` - The Ecto repository module
      - `opts` - Optional configuration:
        - `:limit` - number of records to fetch (default depends on implementation)

    ## Returns

        {items, meta}

    where:
      - `items` is the list of results
      - `meta` includes cursor navigation fields such as:
        - `next_cursor`
        - `prev_cursor`
        - `has_next`
        - `has_prev`

    ## Example

        Pagex.paginate_cursor(Post, %{"after" => cursor}, Repo)
  """
  def paginate_cursor(query, params, repo, opts \\ []) do
    Cursor.paginate(query, params, repo, opts)
  end
end
