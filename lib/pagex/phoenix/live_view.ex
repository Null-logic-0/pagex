defmodule Pagex.Phoenix.LiveView do
  @moduledoc """
  Helpers for Phoenix LiveView pagination.
  """

  @doc """
  Splits params into pagination and filter params.

  Example:
      %{"page" => "2", "search" => "elixir"}

  Returns:
      {%{"page" => "2"}, %{"search" => "elixir"}}
  """
  def extract_params(params) when is_map(params) do
    {pagination, filters} =
      Enum.split_with(params, fn {k, _v} ->
        k in ["page", "page_size", "cursor", "limit"]
      end)

    {
      Map.new(pagination),
      Map.new(filters)
    }
  end
end
