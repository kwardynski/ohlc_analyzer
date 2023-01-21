defmodule OhlcAnalyzer.Math do
  @moduledoc """
  Simple mathematics module
  Decoupled from the Record schema in order to preserve encapsulation
  """

  @doc """
  Calculates the mean of a list of numeric data, rounds to a specified precision
  Invokes Decimal library to handle with float precision errors
  """
  def mean(data, precision \\ 4) when is_list(data) do
    (Enum.sum(data) / length(data))
    |> Decimal.from_float()
    |> Decimal.round(precision)
    |> Decimal.to_float()
  end
end
