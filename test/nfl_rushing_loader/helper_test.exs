defmodule NFLRusingLoader.HelpersTest do
  use ExUnit.Case

  alias NFLRusingLoader.Helpers

  describe "convert string to float" do
    test "handles the string representation of a decimal with comma as separator" do
      assert Helpers.handle_float("1,123") == 1.123
    end

    test "handles the string representation of a decimal number" do
      assert Helpers.handle_float("1.123") == 1.123
    end

    test "handles bad representation of a decimal number" do
      assert Helpers.handle_float("asdasdas1.123adasd") == 1.123
    end

    test "retunrs 0 for invalid numbers" do
      assert Helpers.handle_float("asdasdas1..123adasd") == 0
    end
  end

  describe "convert string to integer" do
    test "handles the string representation of a decimal with comma as separator" do
      assert Helpers.handle_integer("1") == 1
    end

    test "handles bad representation of a decimal number" do
      assert Helpers.handle_integer("123T") == 123
    end

    test "retunrs 0 for invalid numbers" do
      assert Helpers.handle_integer("asdasdasadasd") == 0
    end
  end
end
