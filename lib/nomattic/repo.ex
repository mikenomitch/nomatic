defmodule Nomattic.Repo do
  use Ecto.Repo,
    otp_app: :nomattic,
    adapter: Ecto.Adapters.Postgres
end
