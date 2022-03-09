import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :phx_ecto_example, PhxEctoExample.Repo,
  username: "ecto_example",
  password: "ecto_example",
  hostname: "localhost",
  database: "ecto_example_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phx_ecto_example_web, PhxEctoExampleWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "TJQrJ6AumrvvhPV32SnAoh5QQhW3n7n6EuLY0/Haf6NZjI3xeRzQOQI0160JdmGN",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# In test we don't send emails.
config :phx_ecto_example, PhxEctoExample.Mailer, adapter: Swoosh.Adapters.Test

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
