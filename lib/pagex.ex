defmodule Pagex do
  @moduledoc """
  Documentation for `Pagex`.
  """
  alias Pagex.{Cursor, Offset}

  @doc "..."
  def paginate(query, params, repo, opts \\ []) do
    Offset.paginate(query, params, repo, opts)
  end

  @doc "..."
  def paginate_cursor(query, params, repo, opts \\ []) do
    Cursor.paginate(query, params, repo, opts)
  end
end
