defmodule OhlcAnalyzer.OhlcFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OhlcAnalyzer.Ohlc` context.
  """

  @doc """
  Generate a record.
  """
  def record_fixture(attrs \\ %{}) do
    {:ok, record} =
      attrs
      |> Enum.into(%{
        close: 120.5,
        high: 120.5,
        low: 120.5,
        open: 120.5,
        timestamp: ~U[2023-01-19 01:44:00Z]
      })
      |> OhlcAnalyzer.Ohlc.create_record()

    record
  end
end
