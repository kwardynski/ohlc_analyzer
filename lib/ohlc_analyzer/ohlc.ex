defmodule OhlcAnalyzer.Ohlc do
  @moduledoc """
  The Ohlc context.
  """

  import Ecto.Query, warn: false
  alias OhlcAnalyzer.Repo

  alias OhlcAnalyzer.Ohlc.Record

  @doc """
  Returns the list of records.

  ## Examples

      iex> list_records()
      [%Record{}, ...]

  """
  def list_records do
    Repo.all(Record)
  end

  @doc """
  Gets a single record.

  Raises `Ecto.NoResultsError` if the Record does not exist.

  ## Examples

      iex> get_record!(123)
      %Record{}

      iex> get_record!(456)
      ** (Ecto.NoResultsError)

  """
  def get_record!(id), do: Repo.get!(Record, id)

  @doc """
  Creates a record.

  ## Examples

      iex> create_record(%{field: value})
      {:ok, %Record{}}

      iex> create_record(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_record(attrs \\ %{}) do
    %Record{}
    |> Record.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a record.

  ## Examples

      iex> update_record(record, %{field: new_value})
      {:ok, %Record{}}

      iex> update_record(record, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_record(%Record{} = record, attrs) do
    record
    |> Record.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a record.

  ## Examples

      iex> delete_record(record)
      {:ok, %Record{}}

      iex> delete_record(record)
      {:error, %Ecto.Changeset{}}

  """
  def delete_record(%Record{} = record) do
    Repo.delete(record)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking record changes.

  ## Examples

      iex> change_record(record)
      %Ecto.Changeset{data: %Record{}}

  """
  def change_record(%Record{} = record, attrs \\ %{}) do
    Record.changeset(record, attrs)
  end

  @doc """
  Returns the last `count` records added to the repo
  Defaults to count = 10
  """
  def get_records_by_count(count \\ 10) do
    from(
      r in Record,
      order_by: [desc: r.timestamp],
      limit: ^count
    )
    |> Repo.all()
  end

  @doc """
  Returns all records added to the repo within the last `window` time frame, expected in hours
  Defaults to window = 1 (hour)
  """
  def get_records_by_time(window \\ 1) do
    current_time = DateTime.utc_now()
    window_size = 3600 * window
    cutoff_time = DateTime.add(current_time, -window_size, :second)

    from(
      r in Record,
      order_by: [desc: r.timestamp],
      where: r.timestamp >= ^cutoff_time
    )
    |> Repo.all()
  end
end
