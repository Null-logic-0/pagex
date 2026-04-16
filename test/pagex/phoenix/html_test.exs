defmodule Pagex.Phoenix.HTMLTest do
  use ExUnit.Case, async: true

  alias Pagex.Phoenix.HTML

  # Guard — total < 1
  describe "visible_pages/3 - guard" do
    test "raises FunctionClauseError when total is 0" do
      assert_raise FunctionClauseError, fn -> HTML.visible_pages(1, 0) end
    end

    test "raises FunctionClauseError when total is negative" do
      assert_raise FunctionClauseError, fn -> HTML.visible_pages(1, -1) end
    end
  end

  # Single page
  describe "visible_pages/3 - single page" do
    test "returns [1] when total is 1" do
      assert HTML.visible_pages(1, 1) == [1]
    end
  end

  describe "visible_pages/3 - small total, no ellipsis" do
    test "returns all pages when total fits within window" do
      assert HTML.visible_pages(1, 3) == [1, 2, 3]
    end

    test "returns all pages for total 5, current 3" do
      assert HTML.visible_pages(3, 5) == [1, 2, 3, 4, 5]
    end

    test "no duplicates when start_page is 1" do
      result = HTML.visible_pages(1, 4)
      assert result == Enum.uniq(result)
    end
  end

  describe "visible_pages/3 - left ellipsis" do
    test "shows left ellipsis when current is far from start" do
      result = HTML.visible_pages(8, 10)
      assert :ellipsis in result
      assert 1 in result
      ellipsis_index = Enum.find_index(result, &(&1 == :ellipsis))
      one_index = Enum.find_index(result, &(&1 == 1))
      assert one_index < ellipsis_index
    end

    test "starts with 1 followed by :ellipsis when start_page > 2" do
      result = HTML.visible_pages(7, 10)
      assert List.first(result) == 1
      assert Enum.at(result, 1) == :ellipsis
    end

    test "includes current page in middle" do
      result = HTML.visible_pages(7, 10)
      assert 7 in result
    end

    test "includes last page" do
      result = HTML.visible_pages(7, 10)
      assert 10 in result
    end
  end

  describe "visible_pages/3 - right ellipsis" do
    test "shows right ellipsis when current is far from end" do
      result = HTML.visible_pages(3, 10)
      assert :ellipsis in result
      assert 10 in result
      ellipsis_index = Enum.find_index(result, &(&1 == :ellipsis))
      ten_index = Enum.find_index(result, &(&1 == 10))
      assert ellipsis_index < ten_index
    end

    test "ends with :ellipsis then total when end_page < total - 1" do
      result = HTML.visible_pages(1, 10)
      assert Enum.at(result, -1) == 10
      assert Enum.at(result, -2) == :ellipsis
    end

    test "includes current page" do
      result = HTML.visible_pages(1, 10)
      assert 1 in result
    end

    test "includes page 1" do
      result = HTML.visible_pages(2, 10)
      assert 1 in result
    end
  end

  describe "visible_pages/3 - both ellipses" do
    test "ellipsis appears when current is in the middle of a large range" do
      result = HTML.visible_pages(10, 20)
      assert :ellipsis in result
    end

    test "starts with 1 and ends with total" do
      result = HTML.visible_pages(10, 20)
      assert List.first(result) == 1
      assert List.last(result) == 20
    end

    test "current page is present" do
      result = HTML.visible_pages(10, 20)
      assert 10 in result
    end

    test "contains no duplicates" do
      result = HTML.visible_pages(10, 20)
      assert result == Enum.uniq(result)
    end
  end

  describe "visible_pages/3 - ellipsis boundary conditions" do
    test "no left ellipsis when start_page is exactly 2" do
      result = HTML.visible_pages(4, 10)

      left_ellipsis =
        result
        |> Enum.take_while(&(&1 != 4))
        |> Enum.member?(:ellipsis)

      refute left_ellipsis
    end

    test "no right ellipsis when end_page is exactly total - 1" do
      result = HTML.visible_pages(7, 10)

      right_side =
        result
        |> Enum.reverse()
        |> Enum.take_while(&(&1 != 7))
        |> Enum.member?(:ellipsis)

      refute right_side
    end
  end

  describe "visible_pages/3 - custom window" do
    test "window of 1 shows fewer middle pages" do
      result = HTML.visible_pages(10, 20, 1)
      assert 9 in result
      assert 10 in result
      assert 11 in result
      refute 8 in result
    end

    test "window of 0 shows only current page in middle" do
      result = HTML.visible_pages(10, 20, 0)
      assert 10 in result
      refute 9 in result
      refute 11 in result
    end

    test "large window suppresses both ellipses" do
      result = HTML.visible_pages(10, 15, 10)
      refute :ellipsis in result
      assert result == Enum.to_list(1..15)
    end

    test "result contains no duplicates with any window" do
      for window <- 0..5 do
        result = HTML.visible_pages(5, 10, window)
        assert result == Enum.uniq(result), "duplicates with window=#{window}"
      end
    end
  end

  describe "visible_pages/3 - current at boundaries" do
    test "current is first page" do
      result = HTML.visible_pages(1, 10)
      assert List.first(result) == 1
      assert 10 in result
    end

    test "current is last page" do
      result = HTML.visible_pages(10, 10)
      assert 10 in result
      assert 1 in result
    end

    test "no duplicates when current is first page" do
      result = HTML.visible_pages(1, 10)
      assert result == Enum.uniq(result)
    end

    test "no duplicates when current is last page" do
      result = HTML.visible_pages(10, 10)
      assert result == Enum.uniq(result)
    end
  end
end
