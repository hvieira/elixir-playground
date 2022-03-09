defmodule PhxEctoExample.Repo do
  use Ecto.Repo,
    otp_app: :phx_ecto_example,
    adapter: Ecto.Adapters.Postgres
end
