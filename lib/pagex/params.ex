defmodule Pagex.Params do
  @moduledoc """
  Provides safe normalization of pagination parameters for Pagex.

  This module is responsible for converting raw user input (typically from
  HTTP query params) into validated, predictable pagination values.

  It ensures:
  - Safe handling of missing or invalid values
  - No atom creation from user input (prevents atom exhaustion risks)
  - Consistent defaults across applications
  - Bounded pagination values (min/max constraints)

  ## Supported Parameters

  - `"page"` - current page number (offset pagination)
  - `"page_size"` - number of items per page

  ## Design principles

  - No exceptions for invalid input (safe defaults instead)
  - Pure functions (no side effects)
  - Defensive against malformed external input
  - Stable output shape for downstream pagination logic

  ## Example

      iex> Pagex.Params.normalize(%{"page" => "2", "page_size" => "10"})
      %{page: 2, page_size: 10}

  Invalid values fall back to defaults:

      iex> Pagex.Params.normalize(%{"page" => "abc"})
      %{page: 1, page_size: 20}
  """

  @default_page 1
  @default_page_size 20
  @max_page_size 200

  @doc """
  Normalizes pagination parameters into a safe, validated map.

  This function parses raw input (usually query params) and ensures that
  pagination values are safe to use in database queries.

  ## Parameters

    - `params` - Map of incoming parameters (typically string-keyed)
    - `opts` - Optional overrides:
      - `:default_page` - fallback page number (default: 1)
      - `:default_page_size` - fallback page size (default: 20)
      - `:max_page_size` - maximum allowed page size (default: 200)

  ## Returns

      %{
        page: integer(),
        page_size: integer()
      }

  ## Behavior

  - Non-numeric values fall back to defaults
  - Empty strings are treated as missing values
  - Page is always >= 1
  - Page size is clamped between 1 and `max_page_size`

  ## Example

      Pagex.Params.normalize(%{"page" => "3", "page_size" => "50"})
  """
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
