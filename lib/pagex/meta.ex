defmodule Pagex.Meta do
  @moduledoc """
  Unified pagination metadata structure for Pagex.

  This module defines a single metadata format used across both
  offset and cursor pagination strategies.

  It provides a consistent response contract so that consumers
  (Phoenix, LiveView, JSON APIs) can rely on a stable shape
  regardless of pagination mode.

  ## Design goals

  - Single unified struct for all pagination modes
  - Predictable API for frontend and backend consumers
  - Minimal conditional logic in application code
  - Explicit separation between offset and cursor metadata

  ## Modes

  ### Offset pagination

  Includes page-based navigation:

  - `page`
  - `page_size`
  - `total`
  - `total_pages`
  - `has_next`
  - `has_prev`

  ### Cursor pagination

  Includes keyset navigation:

  - `next_cursor`
  - `prev_cursor`
  - `has_next`
  - `has_prev`

  ## Example (offset)

      %Pagex.Meta{
        mode: :offset,
        page: 2,
        page_size: 20,
        total: 100,
        total_pages: 5,
        has_next: true,
        has_prev: true
      }

  ## Example (cursor)

      %Pagex.Meta{
        mode: :cursor,
        next_cursor: "...",
        prev_cursor: "...",
        has_next: true,
        has_prev: false
      }
  """

  @enforce_keys [:mode]
  defstruct [
    :mode,

    # offset
    :page,
    :page_size,
    :total,
    :total_pages,

    # cursor
    :next_cursor,
    :prev_cursor,

    # shared
    :has_next,
    :has_prev,
    :limit,
    :count
  ]

  @doc """
  Builds metadata for offset-based pagination.

  ## Parameters

    - `attrs` - map containing:
      - `:page` - current page number
      - `:page_size` - items per page
      - `:total` - total number of records (optional)
      - `:count` - number of items in current page

  ## Returns

      %Pagex.Meta{}

  with:
    - computed `total_pages`
    - `has_next` / `has_prev` flags
    - normalized pagination state

  ## Example

      Pagex.Meta.new_offset(%{
        page: 2,
        page_size: 20,
        total: 100,
        count: 20
      })
  """
  def new_offset(attrs) when is_map(attrs) do
    total = Map.get(attrs, :total)

    %__MODULE__{
      mode: :offset,
      page: attrs.page,
      page_size: attrs.page_size,
      total: total,
      total_pages: compute_pages(total, attrs.page_size),
      count: attrs.count,
      limit: attrs.page_size,
      has_next: has_next_offset?(attrs.page, attrs.page_size, total),
      has_prev: attrs.page > 1
    }
  end

  @doc """
  Builds metadata for cursor-based pagination.

  ## Parameters

    - `attrs` - map containing:
      - `:next_cursor` - cursor pointing to next page (if any)
      - `:prev_cursor` - cursor pointing to previous page (if any)
      - `:limit` - number of items fetched
      - `:count` - number of items returned

  ## Returns

      %Pagex.Meta{}

  with cursor navigation fields and boolean flags:
  - `has_next`
  - `has_prev`

  ## Example

      Pagex.Meta.new_cursor(%{
        next_cursor: "abc123",
        prev_cursor: nil,
        limit: 20,
        count: 20
      })
  """
  def new_cursor(attrs) when is_map(attrs) do
    %__MODULE__{
      mode: :cursor,
      next_cursor: attrs.next_cursor,
      prev_cursor: attrs.prev_cursor,
      limit: attrs.limit,
      count: attrs.count,
      has_next: not is_nil(attrs.next_cursor),
      has_prev: not is_nil(attrs.prev_cursor)
    }
  end

  # HELPERS
  defp compute_pages(nil, _), do: nil
  defp compute_pages(_, 0), do: 0
  defp compute_pages(total, page_size), do: div(total + page_size - 1, page_size)

  defp has_next_offset?(_page, _page_size, total) when is_nil(total), do: nil

  defp has_next_offset?(page, page_size, total) do
    page * page_size < total
  end
end
