defmodule OhlcAnalyzer.Ohlc.Record do
  use OhlcAnalyzer.Schema
  import Ecto.Changeset

  schema "records" do
    field :timestamp, :utc_datetime
    field :open, :float
    field :high, :float
    field :low, :float
    field :close, :float

    timestamps()
  end

  @doc false
  def changeset(record, attrs) do
    record
    |> cast(attrs, [:timestamp, :open, :high, :low, :close])
    |> validate_required([:timestamp, :open, :high, :low, :close])
  end
end
