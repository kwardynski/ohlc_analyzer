defmodule OhlcAnalyzer.Ohlc.Record do
  use OhlcAnalyzer.Schema
  import Ecto.Changeset

  schema "records" do
    field :timestamp, :utc_datetime
    field :open, :float
    field :high, :float
    field :low, :float
    field :close, :float
  end

  @doc false
  def changeset(record, attrs) do
    record
    |> cast(attrs, [:timestamp, :open, :high, :low, :close])
    |> validate_required([:timestamp, :open, :high, :low, :close])
  end

  @doc """
  Combines the open, high, low, and close values from a singular Record or a
  list of Records into a 1D array
  """
  def aggregate_record_values(records) when is_list(records) do
    Enum.flat_map(records, &aggregate_record_values/1)
  end

  def aggregate_record_values(%__MODULE__{} = record) do
    [record.open, record.high, record.low, record.close]
  end
end
