defmodule Pagex.Cursor do
  @moduledoc """
  Cursor-based (keyset) pagination for Pagex.

  This module implements **cursor pagination**, which is designed for
  efficient pagination over large datasets where offset-based pagination
  becomes slow or unstable.

  Instead of using `OFFSET`, cursor pagination uses a **position marker**
  (cursor) derived from a stable, ordered field (typically an `id` or timestamp).

  ## Why cursor pagination?

  Cursor pagination provides:

  - Stable performance on large datasets
  - No performance degradation with deep pagination
  - Consistent results even when rows are inserted/deleted
  - Better scalability compared to OFFSET queries

  ## How it works

  1. A query is limited using `LIMIT`
  2. Results are fetched from the database
  3. The last record is encoded into a cursor
  4. The cursor is returned as `next_cursor`

  ## Important notes

  - This implementation assumes ordering by a stable field (e.g. `id`)
  - Cursor encoding is opaque (base64 encoded term)
  - Sorting direction and filtering must remain consistent between requests

  ## Example

      {posts, meta} =
        Pagex.Cursor.paginate(Post, %{}, Repo)

  Returning metadata:

      %Pagex.Meta{
        mode: :cursor,
        next_cursor: "...",
        prev_cursor: nil,
        has_next: true
      }
  """

  import Ecto.Query
  alias Pagex.Meta

  @doc """
  Executes cursor-based pagination on an Ecto query.

  ## Parameters

    - `query` - an `Ecto.Queryable` (schema or query)
    - `_params` - pagination params (reserved for future `after` / `before`)
    - `repo` - the Ecto repository module
    - `opts` - optional configuration:
      - `:limit` - number of records to fetch (default: 20)

  ## Returns

      {items, meta}

  where:

    - `items` is the list of results (limited by `limit`)
    - `meta` contains cursor navigation data:
      - `next_cursor` (encoded pointer to next page)
      - `prev_cursor` (reserved for future use)
      - `has_next`
      - `has_prev`
      - `limit`
      - `count`

  ## Example

      Pagex.Cursor.paginate(Post, %{}, Repo, limit: 50)

  ## Future extension

  Planned support for:
  - `"after"` cursor (forward pagination)
  - `"before"` cursor (backward pagination)
  - deterministic ordering via `order_by`
  """
  def paginate(query, _params, repo, opts \\ []) do
    limit = Keyword.get(opts, :limit, 20)

    query =
      query
      |> limit(^limit)

    items = repo.all(query)

    next_cursor =
      case List.last(items) do
        nil -> nil
        last -> encode_cursor(last.id)
      end

    meta =
      Meta.new_cursor(%{
        limit: limit,
        count: length(items),
        next_cursor: next_cursor,
        prev_cursor: nil
      })

    {items, meta}
  end

  @doc false
  defp encode_cursor(id) do
    id
    |> :erlang.term_to_binary()
    |> Base.url_encode64()
  end
end
