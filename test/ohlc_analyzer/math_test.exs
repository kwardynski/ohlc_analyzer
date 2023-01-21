defmodule OhlcAnalyzer.MathTest do
  use ExUnit.Case, async: true

  alias OhlcAnalyzer.Math

  describe "mean/1" do
    test "accurately calculates the mean of a list of numbers" do
      assert 2.2 == Math.mean([1.1, 2.2, 3.3])
    end

    test "returns singleton list value when given a list of length 1" do
      assert 12 == Math.mean([12])
    end

    test "raises FunctionClauseError if argument is not a list" do
      assert_raise(FunctionClauseError, fn ->
        Math.mean(12)
      end)

      assert_raise(FunctionClauseError, fn ->
        Math.mean(:atom)
      end)
    end

    test "raises ArithmeticError if a member of the argument list is not numeric" do
      invalid_list = [1, 2.12, :atom, "string"]

      assert_raise(ArithmeticError, fn ->
        Math.mean(invalid_list)
      end)
    end
  end
end
