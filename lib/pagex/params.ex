defmodule Pagex.Params do
  @moduledoc """
  Normalizes pagination params safely and consistently.
  """

  @default_page 1
  @default_page_size 20
  @max_page_size 200

  def normalize(params, opts \\ []) when is_map(params) do
    page =
      params
      |> get("page")
      |> parse_positive_integer(Keyword.get(opts, :default_page, @default_page))
      |> max(1)

    page_size =
      params
      |> get("page_size")
      |> parse_positive_integer(Keyword.get(opts, :default_page_size, @default_page_size))
      |> clamp(1, Keyword.get(opts, :max_page_size, @max_page_size))

    %{
      page: page,
      page_size: page_size
    }
  end

  # SAFE ACCESS ONLY (no atoms)
  defp get(params, key) do
    Map.get(params, key)
  end

  # PARSING
  defp parse_positive_integer(nil, default), do: default
  defp parse_positive_integer("", default), do: default

  defp parse_positive_integer(value, default) when is_binary(value) do
    case Integer.parse(value) do
      {int, ""} -> int
      _ -> default
    end
  end

  defp parse_positive_integer(value, _) when is_integer(value) and value > 0, do: value
  defp parse_positive_integer(_, default), do: default

  defp clamp(value, min, max), do: value |> max(min) |> min(max)
end
