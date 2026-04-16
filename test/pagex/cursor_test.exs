defmodule Pagex.CursorTest do
  use ExUnit.Case, async: true

  import Ecto.Query
  import Mox

  alias Pagex.Cursor

  @repo Pagex.MockRepo

  setup :verify_on_exit!

  # Helpers

  defp base_query, do: from(r in "items", as: :r)

  defp make_items(ids), do: Enum.map(ids, &%{id: &1})

  defp encode_cursor(id) do
    id
    |> :erlang.term_to_binary()
    |> Base.url_encode64()
  end

  defp stub_all(items) do
    stub(@repo, :all, fn _query -> items end)
  end

  describe "paginate/4 - return value" do
    test "returns a two-element tuple of {items, meta}" do
      stub_all(make_items([1, 2, 3]))
      result = Cursor.paginate(base_query(), %{}, @repo)
      assert {_items, %Pagex.Meta{}} = result
    end

    test "returns the items fetched from repo as first element" do
      items = make_items([10, 20, 30])
      stub_all(items)
      {returned_items, _meta} = Cursor.paginate(base_query(), %{}, @repo)
      assert returned_items == items
    end
  end

  describe "paginate/4 - limit" do
    test "applies default limit of 20 to query" do
      stub(@repo, :all, fn query ->
        assert %Ecto.Query{limit: %Ecto.Query.LimitExpr{params: [{20, :integer}]}} = query
        make_items([1])
      end)

      Cursor.paginate(base_query(), %{}, @repo)
    end

    test "applies custom limit from opts" do
      stub(@repo, :all, fn query ->
        assert %Ecto.Query{limit: %Ecto.Query.LimitExpr{params: [{5, :integer}]}} = query
        make_items([1])
      end)

      Cursor.paginate(base_query(), %{}, @repo, limit: 5)
    end

    test "meta reflects default limit" do
      stub_all(make_items([1, 2]))
      {_items, meta} = Cursor.paginate(base_query(), %{}, @repo)
      assert meta.limit == 20
    end

    test "meta reflects custom limit" do
      stub_all(make_items([1, 2]))
      {_items, meta} = Cursor.paginate(base_query(), %{}, @repo, limit: 7)
      assert meta.limit == 7
    end
  end

  describe "paginate/4 - next_cursor" do
    test "next_cursor is nil when repo returns empty list" do
      stub_all([])
      {_items, meta} = Cursor.paginate(base_query(), %{}, @repo)
      assert is_nil(meta.next_cursor)
    end

    test "next_cursor encodes the id of the last item" do
      items = make_items([1, 2, 3])
      stub_all(items)
      {_items, meta} = Cursor.paginate(base_query(), %{}, @repo)
      assert meta.next_cursor == encode_cursor(3)
    end

    test "next_cursor encodes last item id when only one item is returned" do
      stub_all(make_items([42]))
      {_items, meta} = Cursor.paginate(base_query(), %{}, @repo)
      assert meta.next_cursor == encode_cursor(42)
    end

    test "next_cursor is a Base64 url-encoded binary string" do
      stub_all(make_items([99]))
      {_items, meta} = Cursor.paginate(base_query(), %{}, @repo)
      assert is_binary(meta.next_cursor)
      assert {:ok, _} = Base.url_decode64(meta.next_cursor)
    end

    test "next_cursor differs for different last-item ids" do
      stub_all(make_items([1, 2, 3]))
      {_, meta_a} = Cursor.paginate(base_query(), %{}, @repo)

      stub_all(make_items([1, 2, 99]))
      {_, meta_b} = Cursor.paginate(base_query(), %{}, @repo)

      refute meta_a.next_cursor == meta_b.next_cursor
    end
  end

  describe "paginate/4 - prev_cursor" do
    test "prev_cursor is always nil (not yet implemented)" do
      stub_all(make_items([1, 2, 3]))
      {_items, meta} = Cursor.paginate(base_query(), %{}, @repo)
      assert is_nil(meta.prev_cursor)
    end

    test "prev_cursor is nil even on empty result" do
      stub_all([])
      {_items, meta} = Cursor.paginate(base_query(), %{}, @repo)
      assert is_nil(meta.prev_cursor)
    end
  end

  describe "paginate/4 - meta" do
    test "mode is :cursor" do
      stub_all(make_items([1]))
      {_items, meta} = Cursor.paginate(base_query(), %{}, @repo)
      assert meta.mode == :cursor
    end

    test "count reflects number of returned items" do
      stub_all(make_items([1, 2, 3]))
      {_items, meta} = Cursor.paginate(base_query(), %{}, @repo)
      assert meta.count == 3
    end

    test "count is 0 on empty result" do
      stub_all([])
      {_items, meta} = Cursor.paginate(base_query(), %{}, @repo)
      assert meta.count == 0
    end

    test "has_next is true when next_cursor is present" do
      stub_all(make_items([1, 2]))
      {_items, meta} = Cursor.paginate(base_query(), %{}, @repo)
      assert meta.has_next == true
    end

    test "has_next is false on empty result" do
      stub_all([])
      {_items, meta} = Cursor.paginate(base_query(), %{}, @repo)
      assert meta.has_next == false
    end

    test "has_prev is false (prev_cursor is nil)" do
      stub_all(make_items([1]))
      {_items, meta} = Cursor.paginate(base_query(), %{}, @repo)
      assert meta.has_prev == false
    end

    test "offset fields are nil" do
      stub_all(make_items([1]))
      {_items, meta} = Cursor.paginate(base_query(), %{}, @repo)
      assert is_nil(meta.page)
      assert is_nil(meta.page_size)
      assert is_nil(meta.total)
      assert is_nil(meta.total_pages)
    end
  end

  describe "encode_cursor (via next_cursor)" do
    test "cursor for integer id round-trips through term_to_binary + url_encode64" do
      id = 123
      stub_all(make_items([id]))
      {_items, meta} = Cursor.paginate(base_query(), %{}, @repo)

      decoded = meta.next_cursor |> Base.url_decode64!() |> :erlang.binary_to_term()
      assert decoded == id
    end

    test "cursor for string id round-trips correctly" do
      id = "uuid-abc-123"
      stub_all([%{id: id}])
      {_items, meta} = Cursor.paginate(base_query(), %{}, @repo)

      decoded = meta.next_cursor |> Base.url_decode64!() |> :erlang.binary_to_term()
      assert decoded == id
    end
  end
end
