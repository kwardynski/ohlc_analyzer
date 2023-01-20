defmodule OhlcAnalyzer.OhlcTest do
  use OhlcAnalyzer.DataCase

  alias OhlcAnalyzer.Ohlc

  describe "records" do
    alias OhlcAnalyzer.Ohlc.Record

    import OhlcAnalyzer.OhlcFixtures

    @invalid_attrs %{close: nil, high: nil, low: nil, open: nil, timestamp: nil}

    test "list_records/0 returns all records" do
      record = record_fixture()
      assert Ohlc.list_records() == [record]
    end

    test "get_record!/1 returns the record with given id" do
      record = record_fixture()
      assert Ohlc.get_record!(record.id) == record
    end

    test "create_record/1 with valid data creates a record" do
      valid_attrs = %{
        close: 120.5,
        high: 120.5,
        low: 120.5,
        open: 120.5,
        timestamp: ~U[2023-01-19 01:44:00Z]
      }

      assert {:ok, %Record{} = record} = Ohlc.create_record(valid_attrs)
      assert record.close == 120.5
      assert record.high == 120.5
      assert record.low == 120.5
      assert record.open == 120.5
      assert record.timestamp == ~U[2023-01-19 01:44:00Z]
    end

    test "create_record/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ohlc.create_record(@invalid_attrs)
    end

    test "update_record/2 with valid data updates the record" do
      record = record_fixture()

      update_attrs = %{
        close: 456.7,
        high: 456.7,
        low: 456.7,
        open: 456.7,
        timestamp: ~U[2023-01-20 01:44:00Z]
      }

      assert {:ok, %Record{} = record} = Ohlc.update_record(record, update_attrs)
      assert record.close == 456.7
      assert record.high == 456.7
      assert record.low == 456.7
      assert record.open == 456.7
      assert record.timestamp == ~U[2023-01-20 01:44:00Z]
    end

    test "update_record/2 with invalid data returns error changeset" do
      record = record_fixture()
      assert {:error, %Ecto.Changeset{}} = Ohlc.update_record(record, @invalid_attrs)
      assert record == Ohlc.get_record!(record.id)
    end

    test "delete_record/1 deletes the record" do
      record = record_fixture()
      assert {:ok, %Record{}} = Ohlc.delete_record(record)
      assert_raise Ecto.NoResultsError, fn -> Ohlc.get_record!(record.id) end
    end

    test "change_record/1 returns a record changeset" do
      record = record_fixture()
      assert %Ecto.Changeset{} = Ohlc.change_record(record)
    end
  end
end
