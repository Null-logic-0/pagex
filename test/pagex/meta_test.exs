defmodule Pagex.MetaTest do
  use ExUnit.Case, async: true

  alias Pagex.Meta

  # new_offset/1
  describe "new_offset/1" do
    test "sets mode to :offset" do
      meta = Meta.new_offset(%{page: 1, page_size: 10, total: 100, count: 10})
      assert meta.mode == :offset
    end

    test "populates page and page_size" do
      meta = Meta.new_offset(%{page: 3, page_size: 15, total: 100, count: 10})
      assert meta.page == 3
      assert meta.page_size == 15
    end

    test "sets limit equal to page_size" do
      meta = Meta.new_offset(%{page: 1, page_size: 20, total: 100, count: 5})
      assert meta.limit == 20
    end

    test "populates count from attrs" do
      meta = Meta.new_offset(%{page: 1, page_size: 10, total: 100, count: 7})
      assert meta.count == 7
    end

    test "computes total_pages correctly (exact division)" do
      meta = Meta.new_offset(%{page: 1, page_size: 10, total: 100, count: 10})
      assert meta.total_pages == 10
    end

    test "computes total_pages correctly (ceiling division)" do
      meta = Meta.new_offset(%{page: 1, page_size: 10, total: 95, count: 10})
      assert meta.total_pages == 10
    end

    test "computes total_pages correctly (single page)" do
      meta = Meta.new_offset(%{page: 1, page_size: 10, total: 3, count: 3})
      assert meta.total_pages == 1
    end

    test "total_pages is 0 when page_size is 0" do
      meta = Meta.new_offset(%{page: 1, page_size: 0, total: 100, count: 0})
      assert meta.total_pages == 0
    end

    test "total_pages is nil when total is nil" do
      meta = Meta.new_offset(%{page: 1, page_size: 10, total: nil, count: 0})
      assert is_nil(meta.total_pages)
    end

    test "has_next is true when more pages remain" do
      # page 1, page_size 10, total 25 → pages 1–3, so has_next
      meta = Meta.new_offset(%{page: 1, page_size: 10, total: 25, count: 10})
      assert meta.has_next == true
    end

    test "has_next is false on last page" do
      # page 3, page_size 10, total 25 → 3*10=30 >= 25
      meta = Meta.new_offset(%{page: 3, page_size: 10, total: 25, count: 5})
      assert meta.has_next == false
    end

    test "has_next is false on only page" do
      meta = Meta.new_offset(%{page: 1, page_size: 10, total: 5, count: 5})
      assert meta.has_next == false
    end

    test "has_next is nil when total is nil" do
      meta = Meta.new_offset(%{page: 1, page_size: 10, total: nil, count: 5})
      assert is_nil(meta.has_next)
    end

    test "has_prev is false on first page" do
      meta = Meta.new_offset(%{page: 1, page_size: 10, total: 100, count: 10})
      assert meta.has_prev == false
    end

    test "has_prev is true on pages beyond first" do
      meta = Meta.new_offset(%{page: 2, page_size: 10, total: 100, count: 10})
      assert meta.has_prev == true
    end

    test "cursor fields are nil" do
      meta = Meta.new_offset(%{page: 1, page_size: 10, total: 10, count: 10})
      assert is_nil(meta.next_cursor)
      assert is_nil(meta.prev_cursor)
    end

    test "total is nil when passed as nil" do
      meta = Meta.new_offset(%{page: 1, page_size: 10, total: nil, count: 0})
      assert is_nil(meta.total)
    end
  end

  # new_cursor/1
  describe "new_cursor/1" do
    test "sets mode to :cursor" do
      meta = Meta.new_cursor(%{next_cursor: "abc", prev_cursor: nil, limit: 10, count: 10})
      assert meta.mode == :cursor
    end

    test "populates next_cursor and prev_cursor" do
      meta =
        Meta.new_cursor(%{next_cursor: "tok_next", prev_cursor: "tok_prev", limit: 10, count: 10})

      assert meta.next_cursor == "tok_next"
      assert meta.prev_cursor == "tok_prev"
    end

    test "populates limit and count" do
      meta = Meta.new_cursor(%{next_cursor: nil, prev_cursor: nil, limit: 25, count: 3})
      assert meta.limit == 25
      assert meta.count == 3
    end

    test "has_next is true when next_cursor is present" do
      meta = Meta.new_cursor(%{next_cursor: "tok", prev_cursor: nil, limit: 10, count: 10})
      assert meta.has_next == true
    end

    test "has_next is false when next_cursor is nil" do
      meta = Meta.new_cursor(%{next_cursor: nil, prev_cursor: nil, limit: 10, count: 5})
      assert meta.has_next == false
    end

    test "has_prev is true when prev_cursor is present" do
      meta = Meta.new_cursor(%{next_cursor: nil, prev_cursor: "tok", limit: 10, count: 10})
      assert meta.has_prev == true
    end

    test "has_prev is false when prev_cursor is nil" do
      meta = Meta.new_cursor(%{next_cursor: nil, prev_cursor: nil, limit: 10, count: 10})
      assert meta.has_prev == false
    end

    test "offset fields are nil" do
      meta = Meta.new_cursor(%{next_cursor: "tok", prev_cursor: nil, limit: 10, count: 10})
      assert is_nil(meta.page)
      assert is_nil(meta.page_size)
      assert is_nil(meta.total)
      assert is_nil(meta.total_pages)
    end
  end

  # struct enforcement
  describe "struct" do
    test "raises when :mode key is missing" do
      assert_raise ArgumentError, fn ->
        struct!(Meta, page: 1)
      end
    end
  end
end
