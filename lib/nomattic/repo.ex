defmodule Nomatic.Repo do
  use Ecto.Repo,
    otp_app: :nomatic,
    adapter: Ecto.Adapters.Postgres
end
