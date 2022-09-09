defmodule DummyProductApi.Repo do
  use Ecto.Repo,
    otp_app: :dummy_product_api,
    adapter: Ecto.Adapters.Postgres
end
