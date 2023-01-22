defmodule OhlcAnalyzerWeb.ApiSpec do
  alias OpenApiSpex.Info
  alias OpenApiSpex.OpenApi
  alias OpenApiSpex.Paths
  alias OpenApiSpex.Server

  @behaviour OpenApi
  def spec do
    %OpenApi{
      servers: [Server.from_endpoint(OhlcAnalyzerWeb.Endpoint)],
      info: %Info{
        title: "RBC Capital Markets STS Take Home Assignment",
        version: to_string(Application.spec(:my_app, :vsn))
      },
      paths: Paths.from_router(OhlcAnalyzerWeb.Router)
    }
    |> OpenApiSpex.resolve_schema_modules()
  end
end
