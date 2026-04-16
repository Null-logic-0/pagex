defmodule Pagex.Phoenix.LiveView do
  @moduledoc """
  Helpers for integrating Pagex with Phoenix LiveView.

  This module provides utilities for working with LiveView pagination,
  particularly for separating pagination state from filtering state.

  In LiveView applications, query parameters often contain both:
  - pagination data (page, page_size, cursor, limit)
  - filter/search data (domain-specific parameters)

  This module helps cleanly separate those concerns so that:

  - Pagination logic stays reusable and consistent
  - Filters remain independent of pagination state
  - Pagex can operate on clean input maps

  ## Example input

      %{
        "page" => "2",
        "page_size" => "20",
        "search" => "elixir",
        "published" => "true"
      }

  ## Example output

      {
        %{"page" => "2", "page_size" => "20"},
        %{"search" => "elixir", "published" => "true"}
      }

  ## Usage in LiveView

      {pagination_params, filters} =
        Pagex.Phoenix.LiveView.extract_params(params)

      query = build_query(filters)

      {items, meta} =
        Pagex.paginate(query, pagination_params, Repo)
  """

  @pagination_keys ["page", "page_size", "cursor", "limit"]

  @doc """
  Splits a parameter map into pagination and filter parameters.

  Pagination keys are extracted into a separate map, while all other
  keys are treated as filter parameters.

  ## Parameters

    - `params` - a map of string-keyed parameters (typically from LiveView)

  ## Returns

      {pagination_params, filter_params}

    - `pagination_params` - map containing pagination-related keys
    - `filter_params` - map containing all non-pagination keys

  ## Pagination keys

  The following keys are treated as pagination-related:

  - `"page"`
  - `"page_size"`
  - `"cursor"`
  - `"limit"`

  ## Example

      Pagex.Phoenix.LiveView.extract_params(%{
        "page" => "1",
        "search" => "elixir"
      })

      # => {%{"page" => "1"}, %{"search" => "elixir"}}
  """
  def extract_params(params) when is_map(params) do
    {pagination, filters} =
      Enum.split_with(params, fn {k, _v} ->
        k in @pagination_keys
      end)

    {
      Map.new(pagination),
      Map.new(filters)
    }
  end
end
