defmodule OhlcAnalyzerWeb.OpenApiSchemas.ErrorMessage do
  require OpenApiSpex

  alias OpenApiSpex.Schema

  OpenApiSpex.schema(
    %{
      title: "ErrorMessage",
      type: :object,
      properties: %{
        message: %Schema{type: :string}
      },
      example: %{"message" => "Not Found"}
    }
  )
end
