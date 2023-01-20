defmodule OhlcAnalyzerWeb.API.RecordView do
  use OhlcAnalyzerWeb, :view

  def render("index.json", %{records: records}) do
    %{data: render_many(records, __MODULE__, "record.json")}
  end

  def render("show.json", %{record: record}) do
    %{data: render_one(record, __MODULE__, "record.json")}
  end

  def render("record.json", %{record: record}) do
    %{
      id: record.id,
      timestamp: record.timestamp,
      open: record.open,
      high: record.high,
      low: record.low,
      close: record.close
    }
  end
end
