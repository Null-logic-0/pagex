defmodule Pagex.Phoenix.LiveViewTest do
  use ExUnit.Case, async: true

  alias Pagex.Phoenix.LiveView

  describe "extract_params/1" do
    test "splits pagination keys from filter keys" do
      params = %{"page" => "2", "search" => "elixir"}
      assert LiveView.extract_params(params) == {%{"page" => "2"}, %{"search" => "elixir"}}
    end

    test "extracts all supported pagination keys" do
      params = %{
        "page" => "1",
        "page_size" => "20",
        "cursor" => "abc123",
        "limit" => "50",
        "name" => "jane"
      }

      {pagination, filters} = LiveView.extract_params(params)

      assert pagination == %{
               "page" => "1",
               "page_size" => "20",
               "cursor" => "abc123",
               "limit" => "50"
             }

      assert filters == %{"name" => "jane"}
    end

    test "returns empty pagination map when no pagination keys present" do
      params = %{"search" => "elixir", "status" => "active"}

      assert LiveView.extract_params(params) ==
               {%{}, %{"search" => "elixir", "status" => "active"}}
    end

    test "returns empty filters map when all keys are pagination keys" do
      params = %{"page" => "3", "page_size" => "10"}
      assert LiveView.extract_params(params) == {%{"page" => "3", "page_size" => "10"}, %{}}
    end

    test "returns two empty maps for an empty map" do
      assert LiveView.extract_params(%{}) == {%{}, %{}}
    end

    test "does not treat similar non-pagination keys as pagination" do
      params = %{"pages" => "5", "my_page" => "1", "search" => "test"}
      {pagination, filters} = LiveView.extract_params(params)

      assert pagination == %{}
      assert filters == %{"pages" => "5", "my_page" => "1", "search" => "test"}
    end

    test "handles multiple filter keys alongside pagination keys" do
      params = %{
        "page" => "2",
        "search" => "elixir",
        "category" => "books",
        "sort" => "asc"
      }

      {pagination, filters} = LiveView.extract_params(params)

      assert pagination == %{"page" => "2"}
      assert filters == %{"search" => "elixir", "category" => "books", "sort" => "asc"}
    end

    test "returns a tuple of two maps" do
      result = LiveView.extract_params(%{"page" => "1"})
      assert {%{}, %{}} = {%{}, %{}}
      assert match?({%{}, %{}}, result)
    end
  end
end
