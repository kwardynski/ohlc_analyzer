defmodule OhlcAnalyzerWeb.API.RecordController do
  use OhlcAnalyzerWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias OhlcAnalyzer.Math
  alias OhlcAnalyzer.Ohlc
  alias OhlcAnalyzer.Ohlc.Record

  alias OhlcAnalyzerWeb.OpenApiSchemas.ErrorMessage
  alias OhlcAnalyzerWeb.OpenApiSchemas.MovingAverageRequest
  alias OhlcAnalyzerWeb.OpenApiSchemas.MovingAverageResponse
  alias OhlcAnalyzerWeb.OpenApiSchemas.RecordResponse

  action_fallback OhlcAnalyzerWeb.FallbackController

  tags ["records"]

  operation :create,
    summary: "Creates a new OHLC Record",
    request_body: {"Record Response", "application/json", RecordResponse},
    responses: [
      ok: {"Record Response", "application/json", RecordResponse}
    ]

  def create(conn, record_params) do
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

  @doc """
  Calculates the moving average for the requested window of OHLC Records
  In the interest of preventing over-optimization and fulfilling the assignment request, this
  function will simply match on the filter.
  It will be the controller's responsibility to ensure that the request returns sufficient data
  in order to calculate a moving average:
    - "last_10_items" returns exactly 10 records
    - "last_1_hour" returns at least 1 record

  Since the filter is a string, later on a parsing function could be introduces to extract
  the window type (count or time), along with the window size, then matched on in the
  with pipeline to allow the user to configure their request
  """
  operation :calculate_moving_average,
    summary: "Calculates the moving average for a group of OHLC Records",
    parameters: [
      window: [
        in: :path,
        description: "Window for moving average calculation",
        type: :string,
        example: "last_10_items or last_1_hour"
      ]
    ],
    request_body: {"Moving Average", "application/json", MovingAverageRequest},
    responses: %{
      200 => {"Moving Average", "application/json", MovingAverageResponse},
      404 => {"Not Found", "application/json", ErrorMessage}
    }

  def calculate_moving_average(conn, %{"window" => "last_10_items"}) do
    window_size = 10

    with(
      records <- Ohlc.get_records_by_count(window_size),
      :ok <- ensure_sufficient_count(length(records), window_size),
      aggregated_values <- Record.aggregate_record_values(records)
    ) do
      data = %{moving_average: Math.mean(aggregated_values)}
      render(conn, "moving_average.json", data)
    else
      _error = error -> error
    end
  end

  def calculate_moving_average(conn, %{"window" => "last_1_hour"}) do
    window_size = 1

    with(
      records <- Ohlc.get_records_by_time(window_size),
      :ok <- ensure_sufficient_window(length(records)),
      aggregated_values <- Record.aggregate_record_values(records)
    ) do
      data = %{moving_average: Math.mean(aggregated_values)}
      render(conn, "moving_average.json", data)
    else
      _error = error -> error
    end
  end

  def calculate_moving_average(_conn, _opts) do
    {:error, :bad_request}
  end

  defp ensure_sufficient_count(num_records, window_size) do
    case num_records == window_size do
      true -> :ok
      false -> {:error, :not_found}
    end
  end

  defp ensure_sufficient_window(num_records) do
    case num_records > 0 do
      true -> :ok
      false -> {:error, :not_found}
    end
  end
end
