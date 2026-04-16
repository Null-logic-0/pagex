defmodule Pagex.Offset do
  import Ecto.Query

  alias Pagex.Params
  alias Pagex.Meta

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
