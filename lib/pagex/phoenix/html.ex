defmodule Pagex.Phoenix.HTML do
  @moduledoc """
  Phoenix HTML helpers for rendering pagination UIs with Pagex.

  This module provides utilities for building page navigation layouts
  suitable for Phoenix templates and LiveView components.

  It focuses on generating a **compact page window**, commonly used in
  pagination UIs such as:

      1 ... 4 5 6 ... 20

  ## Purpose

  Instead of rendering all page numbers, this module generates a
  reduced "windowed" set of visible pages around the current page.

  This improves UX for large datasets by:

  - Reducing visual clutter
  - Keeping navigation focused on nearby pages
  - Preserving access to first and last pages

  ## Output format

  The function returns a list containing:

  - integers (page numbers)
  - `:ellipsis` markers for skipped ranges

  Example:

      [1, :ellipsis, 4, 5, 6, :ellipsis, 20]

  ## Usage

      Pagex.Phoenix.HTML.visible_pages(5, 20, 2)

  """

  @doc """
  Returns a list of visible page numbers for pagination UI.

  This function generates a windowed pagination range centered around
  the current page, including first and last pages with ellipsis
  markers where gaps exist.

  ## Parameters

    - `current` - current page number (integer)
    - `total` - total number of pages (integer)
    - `window` - number of pages to show on each side of current page (default: 2)

  ## Returns

      list()

  A list containing:
    - integers representing page numbers
    - `:ellipsis` atoms indicating skipped ranges

  ## Example

      iex> Pagex.Phoenix.HTML.visible_pages(5, 20, 2)
      [1, :ellipsis, 3, 4, 5, 6, 7, :ellipsis, 20]

  ## Behavior

  - Always includes pages near the current page
  - Includes first page when gap exists
  - Includes last page when gap exists
  - Inserts `:ellipsis` where ranges are skipped
  - Ensures no duplicates in output
  """
  def visible_pages(current, total, window \\ 2)
      when total >= 1 do
    start_page = max(current - window, 1)
    end_page = min(current + window, total)

    middle = Enum.to_list(start_page..end_page)

    left =
      if start_page > 2 do
        [1, :ellipsis]
      else
        Enum.to_list(1..start_page)
      end

    right =
      if end_page < total - 1 do
        [:ellipsis, total]
      else
        Enum.to_list(end_page..total)
      end

    (left ++ middle ++ right)
    |> Enum.uniq()
  end
end
