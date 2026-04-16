defmodule Pagex.ParamsTest do
  use ExUnit.Case, async: true

  alias Pagex.Params

  describe "normalize/2 - page" do
    test "defaults to page 1 when key is absent" do
      assert %{page: 1} = Params.normalize(%{})
    end

    test "defaults to page 1 for empty string" do
      assert %{page: 1} = Params.normalize(%{"page" => ""})
    end

    test "defaults to page 1 for nil" do
      assert %{page: 1} = Params.normalize(%{"page" => nil})
    end

    test "parses valid string integer" do
      assert %{page: 3} = Params.normalize(%{"page" => "3"})
    end

    test "accepts integer value directly" do
      assert %{page: 5} = Params.normalize(%{"page" => 5})
    end

    test "clamps page to 1 when value is 0" do
      assert %{page: 1} = Params.normalize(%{"page" => "0"})
    end

    test "clamps page to 1 when value is negative" do
      assert %{page: 1} = Params.normalize(%{"page" => "-5"})
    end

    test "defaults to 1 for non-numeric string" do
      assert %{page: 1} = Params.normalize(%{"page" => "abc"})
    end

    test "defaults to 1 for float string" do
      assert %{page: 1} = Params.normalize(%{"page" => "1.5"})
    end

    test "does not accept atom key (string-only access)" do
      assert %{page: 1} = Params.normalize(%{page: "3"})
    end

    test "respects custom default_page opt" do
      assert %{page: 2} = Params.normalize(%{}, default_page: 2)
    end

    test "custom default_page is used when page param is invalid" do
      assert %{page: 4} = Params.normalize(%{"page" => "bad"}, default_page: 4)
    end
  end

  describe "normalize/2 - page_size" do
    test "defaults to 20 when key is absent" do
      assert %{page_size: 20} = Params.normalize(%{})
    end

    test "defaults to 20 for empty string" do
      assert %{page_size: 20} = Params.normalize(%{"page_size" => ""})
    end

    test "defaults to 20 for nil" do
      assert %{page_size: 20} = Params.normalize(%{"page_size" => nil})
    end

    test "parses valid string integer" do
      assert %{page_size: 50} = Params.normalize(%{"page_size" => "50"})
    end

    test "accepts integer value directly" do
      assert %{page_size: 10} = Params.normalize(%{"page_size" => 10})
    end

    test "clamps page_size to 1 when value is 0" do
      assert %{page_size: 1} = Params.normalize(%{"page_size" => "0"})
    end

    test "clamps page_size to 1 when value is negative" do
      assert %{page_size: 1} = Params.normalize(%{"page_size" => "-10"})
    end

    test "clamps page_size to max (200) when too large" do
      assert %{page_size: 200} = Params.normalize(%{"page_size" => "9999"})
    end

    test "allows page_size equal to max (200)" do
      assert %{page_size: 200} = Params.normalize(%{"page_size" => "200"})
    end

    test "defaults to 20 for non-numeric string" do
      assert %{page_size: 20} = Params.normalize(%{"page_size" => "big"})
    end

    test "defaults to 20 for float string" do
      assert %{page_size: 20} = Params.normalize(%{"page_size" => "10.5"})
    end

    test "respects custom default_page_size opt" do
      assert %{page_size: 10} = Params.normalize(%{}, default_page_size: 10)
    end

    test "respects custom max_page_size opt" do
      assert %{page_size: 50} = Params.normalize(%{"page_size" => "9999"}, max_page_size: 50)
    end

    test "custom default_page_size is used when page_size param is invalid" do
      assert %{page_size: 15} = Params.normalize(%{"page_size" => "bad"}, default_page_size: 15)
    end
  end

  describe "normalize/2 - return shape" do
    test "returns a map with exactly page and page_size keys" do
      result = Params.normalize(%{"page" => "2", "page_size" => "10"})
      assert Map.keys(result) |> Enum.sort() == [:page, :page_size]
    end

    test "handles both params together" do
      result = Params.normalize(%{"page" => "3", "page_size" => "15"})
      assert result == %{page: 3, page_size: 15}
    end
  end

  describe "normalize/2 - edge cases" do
    test "ignores extra keys in params map" do
      result = Params.normalize(%{"page" => "2", "page_size" => "5", "sort" => "asc"})
      assert result == %{page: 2, page_size: 5}
    end

    test "handles empty map" do
      assert Params.normalize(%{}) == %{page: 1, page_size: 20}
    end

    test "works with string-keyed map (conn.params style)" do
      params = %{"page" => "1", "page_size" => "25"}
      assert Params.normalize(params) == %{page: 1, page_size: 25}
    end

    test "page_size of exactly 1 is not clamped" do
      assert %{page_size: 1} = Params.normalize(%{"page_size" => "1"})
    end

    test "page of exactly 1 is not clamped" do
      assert %{page: 1} = Params.normalize(%{"page" => "1"})
    end

    test "large but valid page number is accepted" do
      assert %{page: 1000} = Params.normalize(%{"page" => "1000"})
    end

    test "combined custom opts all apply" do
      result =
        Params.normalize(
          %{"page" => "bad", "page_size" => "999"},
          default_page: 3,
          default_page_size: 5,
          max_page_size: 100
        )

      assert result == %{page: 3, page_size: 100}
    end
  end
end
