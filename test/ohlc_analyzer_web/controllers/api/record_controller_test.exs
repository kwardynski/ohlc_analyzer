defmodule OhlcAnalyzerWeb.API.RecordControllerTest do
  use OhlcAnalyzerWeb.ConnCase

  import OhlcAnalyzer.OhlcFixtures

  alias OhlcAnalyzer.Ohlc.Record

  @create_attrs %{
    close: 120.5,
    high: 120.5,
    low: 120.5,
    open: 120.5,
    timestamp: ~U[2023-01-19 01:44:00Z]
  }
  @update_attrs %{
    close: 456.7,
    high: 456.7,
    low: 456.7,
    open: 456.7,
    timestamp: ~U[2023-01-20 01:44:00Z]
  }
  @invalid_attrs %{close: nil, high: nil, low: nil, open: nil, timestamp: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all records", %{conn: conn} do
      conn = get(conn, Routes.record_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create record" do
    test "renders record when data is valid", %{conn: conn} do
      conn = post(conn, Routes.record_path(conn, :create), record: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.record_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "close" => 120.5,
               "high" => 120.5,
               "low" => 120.5,
               "open" => 120.5,
               "timestamp" => "2023-01-19T01:44:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.record_path(conn, :create), record: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update record" do
    setup [:create_record]

    test "renders record when data is valid", %{conn: conn, record: %Record{id: id} = record} do
      conn = put(conn, Routes.record_path(conn, :update, record), record: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.record_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "close" => 456.7,
               "high" => 456.7,
               "low" => 456.7,
               "open" => 456.7,
               "timestamp" => "2023-01-20T01:44:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, record: record} do
      conn = put(conn, Routes.record_path(conn, :update, record), record: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete record" do
    setup [:create_record]

    test "deletes chosen record", %{conn: conn, record: record} do
      conn = delete(conn, Routes.record_path(conn, :delete, record))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.record_path(conn, :show, record))
      end
    end
  end

  describe "calculate_moving_average/2" do
    setup do
      %{
        count_url: "/api/average?window=last_10_items",
        time_url: "/api/average?window=last_1_hour",
        invalid_url: "/api/average?window=thisRequestIsInvalid"
      }
    end

    test "returns error if request is poorly formed", %{conn: conn, invalid_url: invalid_url} do
      conn
      |> get(invalid_url)
      |> response(400)
    end

    test "last_10_items request returns error if less than 10 records found", %{
      conn: conn,
      count_url: count_url
    } do
      # Insert 9 records
      for _n <- 1..9, do: record_fixture()

      conn
      |> get(count_url)
      |> response(404)
    end

    test "last_1_hour request returns error if 0 records found", %{conn: conn, time_url: time_url} do
      conn
      |> get(time_url)
      |> response(404)
    end

    test "last_10_items request returns correct average if 10 records found", %{
      conn: conn,
      count_url: count_url
    } do
      # Insert 10 records
      for _n <- 1..10 do
        record_fixture(%{open: 1.1, high: 2.2, low: 3.3, close: 4.4})
      end

      response =
        conn
        |> get(count_url)
        |> json_response(200)

      assert response == %{"moving_average" => 2.75}
    end

    test "last_1_hour request returns correct average if >1 record found", %{
      conn: conn,
      time_url: time_url
    } do
      # Insert 5 "older" records
      for _n <- 1..5 do
        record_fixture(%{timestamp: ~U[2021-01-01 00:00:00Z]})
      end

      # Insert 2 "current" records
      for _n <- 1..10 do
        record_fixture(%{
          open: 1.1,
          high: 2.2,
          low: 3.3,
          close: 4.4,
          timestamp: DateTime.utc_now()
        })
      end

      response =
        conn
        |> get(time_url)
        |> json_response(200)

      assert response == %{"moving_average" => 2.75}
    end
  end

  defp create_record(_) do
    record = record_fixture()
    %{record: record}
  end
end
