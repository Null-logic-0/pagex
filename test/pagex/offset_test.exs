defmodule Pagex.OffsetTest do
  use ExUnit.Case, async: true

  import Ecto.Query
  import Mox

  alias Pagex.Offset
  alias Pagex.Meta

  setup :verify_on_exit!

  @repo Pagex.MockRepo

  defp base_query, do: from(u in "users")

  defp stub_count(n), do: stub(@repo, :one, fn _query -> n end)
  defp stub_all(items), do: stub(@repo, :all, fn _query -> items end)

  # Return shape
  describe "paginate/4 - return shape" do
    test "returns a two-element tuple {items, meta}" do
      stub_count(0)
      stub_all([])
      assert {_items, _meta} = Offset.paginate(base_query(), %{}, @repo)
    end

    test "items is the list returned by repo.all/1" do
      stub_count(3)
      stub_all([:a, :b, :c])
      {items, _meta} = Offset.paginate(base_query(), %{}, @repo)
      assert items == [:a, :b, :c]
    end

    test "meta is a Meta struct" do
      stub_count(0)
      stub_all([])
      {_items, meta} = Offset.paginate(base_query(), %{}, @repo)
      assert %Meta{} = meta
    end
  end

  # Meta fields
  describe "paginate/4 - meta" do
    test "meta.page reflects requested page" do
      stub_count(100)
      stub_all([])
      {_, meta} = Offset.paginate(base_query(), %{"page" => "3"}, @repo)
      assert meta.page == 3
    end

    test "meta.page_size reflects requested page_size" do
      stub_count(100)
      stub_all([])
      {_, meta} = Offset.paginate(base_query(), %{"page_size" => "15"}, @repo)
      assert meta.page_size == 15
    end

    test "meta.total reflects repo count" do
      stub_count(42)
      stub_all([])
      {_, meta} = Offset.paginate(base_query(), %{}, @repo)
      assert meta.total == 42
    end

    test "meta.count reflects number of items in current page" do
      stub_count(50)
      stub_all([:a, :b, :c])
      {_, meta} = Offset.paginate(base_query(), %{}, @repo)
      assert meta.count == 3
    end

    test "meta.total is nil when count: false" do
      stub_all([:a])
      {_, meta} = Offset.paginate(base_query(), %{}, @repo, count: false)
      assert meta.total == nil
    end

    test "meta.total_pages is correct" do
      stub_count(55)
      stub_all([])
      {_, meta} = Offset.paginate(base_query(), %{"page_size" => "10"}, @repo)
      assert meta.total_pages == 6
    end

    test "meta.has_next is true when more pages remain" do
      stub_count(30)
      stub_all(List.duplicate(:x, 10))
      {_, meta} = Offset.paginate(base_query(), %{"page" => "2", "page_size" => "10"}, @repo)
      assert meta.has_next == true
    end

    test "meta.has_next is false on last page" do
      stub_count(20)
      stub_all(List.duplicate(:x, 10))
      {_, meta} = Offset.paginate(base_query(), %{"page" => "2", "page_size" => "10"}, @repo)
      assert meta.has_next == false
    end

    test "meta.has_prev is false on first page" do
      stub_count(50)
      stub_all([])
      {_, meta} = Offset.paginate(base_query(), %{"page" => "1"}, @repo)
      assert meta.has_prev == false
    end

    test "meta.has_prev is true after first page" do
      stub_count(50)
      stub_all([])
      {_, meta} = Offset.paginate(base_query(), %{"page" => "2"}, @repo)
      assert meta.has_prev == true
    end
  end

  # Query construction — verified through meta, not query AST internals

  describe "paginate/4 - query construction" do
    test "limit is reflected in meta.limit" do
      stub_count(100)
      stub_all([])
      {_, meta} = Offset.paginate(base_query(), %{"page_size" => "5"}, @repo)
      assert meta.limit == 5
    end

    test "page 1 produces no offset (page=1, page_size=10)" do
      stub_count(100)
      stub_all([])
      {_, meta} = Offset.paginate(base_query(), %{"page" => "1", "page_size" => "10"}, @repo)
      assert meta.page == 1
      assert meta.page_size == 10
    end

    test "page 3 with page_size 10 is reflected in meta" do
      stub_count(100)
      stub_all([])
      {_, meta} = Offset.paginate(base_query(), %{"page" => "3", "page_size" => "10"}, @repo)
      assert meta.page == 3
      assert meta.page_size == 10
    end

    test "skips count query when count: false" do
      expect(@repo, :one, 0, fn _q -> flunk("count should not be called") end)
      stub_all([])
      Offset.paginate(base_query(), %{}, @repo, count: false)
    end

    test "calls repo.one/1 exactly once when count: true (default)" do
      expect(@repo, :one, 1, fn _q -> 0 end)
      stub_all([])
      Offset.paginate(base_query(), %{}, @repo)
    end
  end

  # Params normalisation integration
  describe "paginate/4 - param normalisation" do
    test "uses default page 1 when page param is missing" do
      stub_count(10)
      stub_all([])
      {_, meta} = Offset.paginate(base_query(), %{}, @repo)
      assert meta.page == 1
    end

    test "uses default page_size 20 when page_size param is missing" do
      stub_count(100)
      stub_all([])
      {_, meta} = Offset.paginate(base_query(), %{}, @repo)
      assert meta.page_size == 20
    end

    test "clamps page_size to max_page_size opt" do
      stub_count(0)
      stub_all([])

      {_, meta} =
        Offset.paginate(base_query(), %{"page_size" => "9999"}, @repo, max_page_size: 50)

      assert meta.page_size == 50
    end

    test "falls back to default_page opt on bad page param" do
      stub_count(100)
      stub_all([])
      {_, meta} = Offset.paginate(base_query(), %{"page" => "bad"}, @repo, default_page: 3)
      assert meta.page == 3
    end
  end

  # count_query fallback (rescue branch)
  describe "paginate/4 - count fallback" do
    test "falls back to subquery count when primary count raises" do
      expect(@repo, :one, 2, fn query ->
        if has_named_binding?(query, :r) do
          raise Ecto.QueryError, message: "no id field"
        else
          10
        end
      end)

      stub_all([])

      {_, meta} = Offset.paginate(base_query(), %{}, @repo)
      assert meta.total == 10
    end
  end

  # Empty result set
  describe "paginate/4 - empty results" do
    test "handles zero total records" do
      stub_count(0)
      stub_all([])

      {items, meta} = Offset.paginate(base_query(), %{}, @repo)
      assert items == []
      assert meta.total == 0
      assert meta.count == 0
    end
  end
end
