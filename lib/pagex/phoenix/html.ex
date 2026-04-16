defmodule Pagex.Phoenix.HTML do
  @moduledoc """
  Phoenix HTML helpers for Pagex pagination.
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
