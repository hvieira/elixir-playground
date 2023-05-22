import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :dummy_product_api, DummyProductApi.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "dummy_product_api_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dummy_product_api_web, DummyProductApiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "pbluaUaPCh4AuuaXcBILnwAKkdxGg/RGY+8Zhtt3SVw0X9znwpoUmx7xvl78X6W+",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# JOKEN configuration
# https://github.com/joken-elixir/joken/issues/294

# we can extract a pub key from a pem with
# openssl rsa -in keys/dev_auth_2048.pem -pubout > keys/dev_auth_2048.pub

# kid can be the sha1 of the key
# openssl sha1 keys/dev_auth_2048.pem
# SHA1(keys/dev_auth_2048.pem)= 358940cccdde245c1adc3fc1ca0cef0e11e1259b

new_private_key_contents = File.read!("./keys/test_new_2048.pem")

old_private_key_contents = File.read!("./keys/test_old_2048.pem")

config :joken,
  new_signer: [
    signer_alg: "RS256",
    key_pem: new_private_key_contents,
    # TODO this could be computed here instead of hardcoded - see if it is possible
    jose_extra_headers: %{"kid" => "27990a52048ad51645b1b55988bec56e0a6a96ae"}
  ],
  old_signer: [
    signer_alg: "RS256",
    key_pem: old_private_key_contents,
    # TODO this could be computed here instead of hardcoded - see if it is possible
    jose_extra_headers: %{"kid" => "628492d6e921440fa8f979d7b9d04beb4ac786a7"}
  ]

#  default_signer:
#    [
#      signer_alg: "RS256",
#      key_pem: new_private_key_contents,
#      jose_extra_headers: %{"kid" => "27990a52048ad51645b1b55988bec56e0a6a96ae"}
#    ]
