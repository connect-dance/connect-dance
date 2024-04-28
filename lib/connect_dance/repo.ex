defmodule ConnectDance.Repo do
  use Ecto.Repo,
    otp_app: :connect_dance,
    adapter: Ecto.Adapters.Postgres
end
