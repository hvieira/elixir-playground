# DummyProductApiWeb

## Migrations
See `config.exs` for migration defaults and docs for such options in [here](https://hexdocs.pm/ecto_sql/Ecto.Migration.html#timestamps/1)


### Use UUIDs as default for primary keys
```
config :dummy_product_api, DummyProductApi.Repo,
  migration_primary_key: [name: :id, type: :binary_id]
```

## Product model

See `base_model.ex` for:
- UUID usage for identifiers
- Use timestamps with UTC timezone by default

In iex, we can insert a new product like so
```shell
alias DummyProductApi.Product
%Product{} |> Product.changeset(%{name: "<name>", description: "<description>", value: 1}) |> DummyProductApi.Repo.insert()
```

### TO REMOVE ONCE THINGS ARE PROPER

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
