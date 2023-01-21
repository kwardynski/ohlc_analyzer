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

    test "get_records_by_count/0 returns 10 recent records" do
      # Insert 5 records where all values = 2
      for _n <- 1..5 do
        record_fixture(%{open: 2, high: 2, low: 2, close: 2, timestamp: DateTime.utc_now})
      end

      # Insert 10 records where all values = 1
      # Wait 1 second - see README for explanation
      Process.sleep(1000)
      for _n <- 1..10 do
        record_fixture(%{open: 1, high: 1, low: 1, close: 1, timestamp: DateTime.utc_now})
      end

      # Retrieve 10 records, assert all records have all values equal to 1
      records = Ohlc.get_records_by_count()
      assert length(records) == 10
      Enum.each(records, fn(record) ->
        assert record.open == 1
        assert record.high == 1
        assert record.low == 1
        assert record.close == 1
      end)
    end

    test "get_records_by_count/1 returns 'count' records" do
      # Insert 5 records where all values = 2
      for _n <- 1..5 do
        record_fixture(%{open: 2, high: 2, low: 2, close: 2, timestamp: DateTime.utc_now})
      end

      # Insert 5 records where all values = 1
      # Wait 1 second - see README for explanation
      Process.sleep(1000)
      for _n <- 1..5 do
        record_fixture(%{open: 1, high: 1, low: 1, close: 1, timestamp: DateTime.utc_now})
      end

      # Retrieve 5 records, assert all records have all values equal to 1
      records = Ohlc.get_records_by_count(5)
      assert length(records) == 5
      Enum.each(records, fn(record) ->
        assert record.open == 1
        assert record.high == 1
        assert record.low == 1
        assert record.close == 1
      end)
    end

    test "get_records_by_count returns error tuple if less records retreived than requested" do
      assert {:error, :insufficient_records} = Ohlc.get_records_by_count
    end
  end
end
