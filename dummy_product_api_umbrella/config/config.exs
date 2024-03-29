# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Configure Mix tasks and generators
config :dummy_product_api,
  ecto_repos: [DummyProductApi.Repo]

config :dummy_product_api_web,
  ecto_repos: [DummyProductApi.Repo],
  generators: [context_app: :dummy_product_api]

# Configures the endpoint
config :dummy_product_api_web, DummyProductApiWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: DummyProductApiWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: DummyProductApi.PubSub,
  live_view: [signing_salt: "QlqFrIS0"]

config :dummy_product_api, DummyProductApi.Repo,
  migration_primary_key: [name: :id, type: :binary_id]

config :dummy_product_api,
  user_store: DummyProductApi.UserDatabaseStore,
  product_store: DummyProductApi.ProductDatabaseStore

config :dummy_product_api_web,
  # The audience of a token is the intended recipient of the token. The audience value is a string -- typically, the base address of the resource being accessed, such as https://contoso.com.
  audience: "dummy_product.com"

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/dummy_product_api_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
