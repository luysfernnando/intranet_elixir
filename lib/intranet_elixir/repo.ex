defmodule IntranetElixir.Repo do
  use Ecto.Repo,
    otp_app: :intranet_elixir,
    adapter: Ecto.Adapters.Postgres
end
