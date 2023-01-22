defmodule OhlcAnalyzerWeb.OpenApiSchemas.MovingAverageRequest do
  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(
    %{
      title: "MovingAverageRequest",
      description: "Moving Average Request Schema",
      type: :object,
      properties: %{
        window: %Schema{
          type: :string,
          description: "Window of OHLC Records upon which to perform the averaging"
        }
      },
      example: %{
        window: "last_10_items"
      }
    }
  )
end

defmodule OhlcAnalyzerWeb.OpenApiSchemas.MovingAverageResponse do
  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(
    %{
      title: "MovingAverageResponse",
      description: "Response Schema for a Moving Average Request",
      type: :object,
      properties: %{
        moving_average: %Schema{
          type: :float,
          description: "The Moving Average calculated from a list of OHLC Records"
        }
      },
      example: %{
        moving_average: 12.23
      }
    }
  )
end
