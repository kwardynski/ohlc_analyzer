# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     OhlcAnalyzer.Repo.insert!(%OhlcAnalyzer.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule SeedHelpers do
  alias OhlcAnalyzer.Ohlc

  def insert_record(value, timestamp) do
    Ohlc.create_record(%{
      open: value,
      high: value,
      low: value,
      close: value,
      timestamp: timestamp
    })
  end
end

alias OhlcAnalyzer.Repo
alias OhlcAnalyzer.Ohlc
alias OhlcAnalyzer.Ohlc.Record

if Mix.env() == :dev do
  IO.puts("Seeding demo data for dev")
  IO.puts("  - 5 'current' records - timestamp = DateTime.utc_now")
  IO.puts("  - 5 'old' records - timestamp = Jan 01, 2023")
  IO.puts("  - 5 'older' records, timestamp = Jan 01, 2022")
  IO.puts("window=last_1_hour should return a result of 1.1")
  IO.puts("window=last_10_items should return a result of 2.2")

  Repo.delete_all(Record)

  for _n <- 1..5, do: SeedHelpers.insert_record(1.234, ~U[2022-01-01 12:00:00Z])
  for _n <- 1..5, do: SeedHelpers.insert_record(3.3, ~U[2023-01-01 12:00:00Z])
  for _n <- 1..5, do: SeedHelpers.insert_record(1.1, DateTime.utc_now())
end
