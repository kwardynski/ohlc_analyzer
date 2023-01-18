defmodule OhlcAnalyzer.Repo do
  use Ecto.Repo,
    otp_app: :ohlc_analyzer,
    adapter: Ecto.Adapters.Postgres
end
