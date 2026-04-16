defmodule PagexTest do
  use ExUnit.Case, async: true

  import Ecto.Query
  import Mox

  @repo Pagex.MockRepo

  setup :verify_on_exit!

  defp base_query, do: from(r in "items", as: :r)
  defp stub_all(items), do: stub(@repo, :all, fn _query -> items end)
  defp stub_one(val), do: stub(@repo, :one, fn _query -> val end)

  describe "paginate/4" do
    test "returns a {items, meta} tuple" do
      stub_all([])
      stub_one(0)
      assert {_items, %Pagex.Meta{}} = Pagex.paginate(base_query(), %{}, @repo)
    end

    test "meta mode is :offset" do
      stub_all([])
      stub_one(0)
      {_items, meta} = Pagex.paginate(base_query(), %{}, @repo)
      assert meta.mode == :offset
    end

    test "returns items from repo" do
      items = [%{id: 1}, %{id: 2}]
      stub_all(items)
      stub_one(2)
      {returned, _meta} = Pagex.paginate(base_query(), %{}, @repo)
      assert returned == items
    end

    test "passes opts through to Offset (count: false skips count query)" do
      stub_all([%{id: 1}])
      # repo.one must NOT be called when count: false
      expect(@repo, :one, 0, fn _ -> flunk("should not call one/1") end)
      {_items, meta} = Pagex.paginate(base_query(), %{}, @repo, count: false)
      assert is_nil(meta.total)
    end

    test "passes params through to Offset (page respected)" do
      stub_all([])
      stub_one(0)
      {_items, meta} = Pagex.paginate(base_query(), %{"page" => 3}, @repo)
      assert meta.page == 3
    end
  end

  describe "paginate_cursor/4" do
    test "returns a {items, meta} tuple" do
      stub_all([])
      assert {_items, %Pagex.Meta{}} = Pagex.paginate_cursor(base_query(), %{}, @repo)
    end

    test "meta mode is :cursor" do
      stub_all([])
      {_items, meta} = Pagex.paginate_cursor(base_query(), %{}, @repo)
      assert meta.mode == :cursor
    end

    test "returns items from repo" do
      items = [%{id: 10}, %{id: 20}]
      stub_all(items)
      {returned, _meta} = Pagex.paginate_cursor(base_query(), %{}, @repo)
      assert returned == items
    end

    test "passes opts through to Cursor (custom limit reflected in meta)" do
      stub_all([])
      {_items, meta} = Pagex.paginate_cursor(base_query(), %{}, @repo, limit: 5)
      assert meta.limit == 5
    end

    test "next_cursor is nil when result is empty" do
      stub_all([])
      {_items, meta} = Pagex.paginate_cursor(base_query(), %{}, @repo)
      assert is_nil(meta.next_cursor)
    end

    test "next_cursor is set when items are returned" do
      stub_all([%{id: 1}, %{id: 2}])
      {_items, meta} = Pagex.paginate_cursor(base_query(), %{}, @repo)
      refute is_nil(meta.next_cursor)
    end
  end

  describe "isolation" do
    test "paginate and paginate_cursor can be called in the same test without interference" do
      stub_all([%{id: 1}])
      stub_one(1)

      {_items, offset_meta} = Pagex.paginate(base_query(), %{}, @repo)
      {_items, cursor_meta} = Pagex.paginate_cursor(base_query(), %{}, @repo)

      assert offset_meta.mode == :offset
      assert cursor_meta.mode == :cursor
    end
  end
end
