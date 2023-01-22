defmodule OhlcAnalyzerWeb.OpenApiSchemas.Record do
  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(
    %{
      title: "Record",
      description: "An OHLC record",
      type: :object,
      properties: %{
        timestamp: %Schema{
          type: :string,
          description: "Timestamp associated with the record",
          format: :"date-time"
        },
        open: %Schema{type: :float, description: "Record's OPENING value"},
        high: %Schema{type: :float, description: "Record's HIGHEST value"},
        low: %Schema{type: :float, description: "Record's LOWEST value"},
        close: %Schema{type: :float, description: "Record's CLOSING value"}
      },
      required: [:open, :high, :low, :close],
      example: %{
        "timestamp" => "2021-09-01T08:00:00Z",
        "open" => 16.83,
        "high" => 19.13,
        "low" => 15.49,
        "close" => 16.04
      }
    }
  )
end

defmodule OhlcAnalyzerWeb.OpenApiSchemas.RecordResponse do
  alias OhlcAnalyzerWeb.OpenApiSchemas.Record

  require OpenApiSpex

  OpenApiSpex.schema(
    %{
      title: "RecordResponse",
      description: "Response schema for a single Record",
      type: :object,
      properties: %{
        data: Record
      },
      example: %{
        "timestamp" => "2021-09-01T08:00:00Z",
        "open" => 16.83,
        "high" => 19.13,
        "low" => 15.49,
        "close" => 16.04
      }
    }
  )
end
