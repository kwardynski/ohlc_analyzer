defmodule OhlcAnalyzerWeb.API.RecordController do
  use OhlcAnalyzerWeb, :controller

  alias OhlcAnalyzer.Ohlc
  alias OhlcAnalyzer.Ohlc.Record

  action_fallback OhlcAnalyzerWeb.FallbackController

  def index(conn, _params) do
    records = Ohlc.list_records()
    render(conn, "index.json", records: records)
  end

  def create(conn, %{"record" => record_params}) do
    with {:ok, %Record{} = record} <- Ohlc.create_record(record_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.record_path(conn, :show, record))
      |> render("show.json", record: record)
    end
  end

  def show(conn, %{"id" => id}) do
    record = Ohlc.get_record!(id)
    render(conn, "show.json", record: record)
  end

  def update(conn, %{"id" => id, "record" => record_params}) do
    record = Ohlc.get_record!(id)

    with {:ok, %Record{} = record} <- Ohlc.update_record(record, record_params) do
      render(conn, "show.json", record: record)
    end
  end

  def delete(conn, %{"id" => id}) do
    record = Ohlc.get_record!(id)

    with {:ok, %Record{}} <- Ohlc.delete_record(record) do
      send_resp(conn, :no_content, "")
    end
  end
end
