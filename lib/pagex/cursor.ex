defmodule Pagex.Cursor do
  import Ecto.Query

  alias Pagex.Meta

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

  defp encode_cursor(id) do
    id
    |> :erlang.term_to_binary()
    |> Base.url_encode64()
  end
end
