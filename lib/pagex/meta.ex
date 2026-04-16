defmodule Pagex.Meta do
  @moduledoc """
  Unified pagination metadata for offset and cursor modes.
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

  # OFFSET BUILDER
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

  # CURSOR BUILDER
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
