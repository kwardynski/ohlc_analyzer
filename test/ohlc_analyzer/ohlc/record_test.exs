defmodule OhlcAnalyzer.Ohlc.RecordTest do
  use OhlcAnalyzer.DataCase, async: true

  alias OhlcAnalyzer.Ohlc.Record
  alias OhlcAnalyzer.OhlcFixtures

  describe "aggregate_record_values/1" do
    test "returns numeric values from a single Record as a list" do
      record_values =
        %{open: 1.1, high: 2.2, low: 3.3, close: 4.4}
        |> OhlcFixtures.record_fixture()
        |> Record.aggregate_record_values()

      assert record_values == [1.1, 2.2, 3.3, 4.4]
    end

    test "returns numeric values from a list of Records as a list" do
      record_values =
        [
          %{open: 1.1, high: 2.2, low: 3.3, close: 4.4},
          %{open: 5.5, high: 6.6, low: 7.7, close: 8.8},
          %{open: 9.9, high: 10.1, low: 11.11, close: 12.12}
        ]
        |> Enum.map(&OhlcFixtures.record_fixture/1)
        |> Record.aggregate_record_values()

      assert record_values == [1.1, 2.2, 3.3, 4.4, 5.5, 6.6, 7.7, 8.8, 9.9, 10.1, 11.11, 12.12]
    end

    test "raises FunctionClauseError if argument is not a Record schema" do
      assert_raise(FunctionClauseError, fn ->
        Record.aggregate_record_values(:atom)
      end)

      assert_raise(FunctionClauseError, fn ->
        Record.aggregate_record_values(12)
      end)
    end

    test "raises FunctionClauseError if element in argument list is not a Record schema" do
      invalid_list = [
        OhlcFixtures.record_fixture(%{open: 1.1, high: 2.2, low: 3.3, close: 4.4}),
        "not a Record Schema"
      ]

      assert_raise(FunctionClauseError, fn ->
        Record.aggregate_record_values(invalid_list)
      end)
    end
  end
end
