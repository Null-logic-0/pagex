defmodule Pagex.Offset do
  @moduledoc """
  Offset-based pagination implementation for Pagex.

  This module provides traditional page-based pagination using SQL
  `LIMIT` and `OFFSET`.

  It is designed for:
  - Small to medium datasets
  - Simple UI pagination (page numbers)
  - Compatibility with Phoenix and Ecto queries

  ## How it works

  Given a query and pagination params, it:

  1. Normalizes input via `Pagex.Params`
  2. Computes `OFFSET = (page - 1) * page_size`
  3. Executes the paginated query
  4. Optionally runs a count query for metadata
  5. Returns `{items, meta}`

  ## When to use

  Offset pagination is suitable when:
  - Dataset size is moderate
  - Deep pagination is not performance-critical
  - Total count is required for UI page indicators

  For large datasets or deep pagination, consider cursor pagination instead.

  ## Example

      {posts, meta} =
        Pagex.Offset.paginate(Post, %{"page" => "2"}, Repo)

  """
  import Ecto.Query

  alias Pagex.Params
  alias Pagex.Meta

  @doc """
  Executes offset-based pagination on an Ecto query.

  ## Parameters

    - `query` - an `Ecto.Queryable` (schema or query)
    - `params` - map containing `"page"` and `"page_size"`
    - `repo` - the Ecto repository module
    - `opts` - optional configuration:
      - `:count` (boolean, default: true) - whether to run count query
      - `:default_page`
      - `:default_page_size`
      - `:max_page_size`

  ## Returns

      {items, meta}

  where:

    - `items` is a list of results for the current page
    - `meta` contains pagination metadata:
      - `page`
      - `page_size`
      - `total` (if enabled)
      - `count` (items in current page)

  ## Example

      Pagex.Offset.paginate(Post, %{"page" => "1"}, Repo)

  ## Performance note

  When `:count` is enabled, an additional `COUNT(*)` query is executed.
  Disable it for faster queries when total pages are not required.
  """
  def paginate(query, params, repo, opts \\ []) do
    validated = Params.normalize(params, opts)
    %{page: page, page_size: page_size} = validated

    offset = (page - 1) * page_size

    total =
      if Keyword.get(opts, :count, true) do
        count_query(query, repo)
      else
        nil
      end

    items =
      query
      |> limit(^page_size)
      |> offset(^offset)
      |> repo.all()

    meta =
      Meta.new_offset(%{
        page: page,
        page_size: page_size,
        total: total,
        count: length(items)
      })

    {items, meta}
  end

  @doc false
  defp count_query(query, repo) do
    query
    |> exclude(:preload)
    |> exclude(:order_by)
    |> exclude(:select)
    |> from(as: :r)
    |> select([r: r], count(r.id))
    |> repo.one()
  rescue
    _ ->
      query
      |> exclude(:preload)
      |> exclude(:order_by)
      |> subquery()
      |> select([r], count())
      |> repo.one()
  end
end
