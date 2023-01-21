defmodule OhlcAnalyzer.Repo.Migrations.CreateRecords do
  use Ecto.Migration

  def change do
    create table(:records, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :timestamp, :utc_datetime
      add :open, :float
      add :high, :float
      add :low, :float
      add :close, :float
    end
  end
end
