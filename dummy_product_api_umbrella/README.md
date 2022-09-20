# DummyProductApi.Umbrella

## Migrations
See `config.exs` for migration defaults and docs for such options in [here](https://hexdocs.pm/ecto_sql/Ecto.Migration.html#timestamps/1)


### Use UUIDs as default for primary keys
```
config :dummy_product_api, DummyProductApi.Repo,
  migration_primary_key: [name: :id, type: :binary_id]
```

## Building the initial Product model

See `base_model.ex` for:
- UUID usage for identifiers
- Use timestamps with UTC timezone by default

In iex, we can insert a new product like so
```shell
alias DummyProductApi.Product
%Product{} |> Product.changeset(%{name: "<name>", description: "<description>", value: 1}) |> DummyProductApi.Repo.insert()
```

## Building foreign keys
See `dummy_product_api_umbrella/apps/dummy_product_api/priv/repo/migrations/20220916154513_product_reference_user.exs`
where a user ownership of the product is defined.
```
  def change do
    alter table("products") do
      add :owner_id, references("users", type: :binary_id, column: "id"), null: false
    end
  end
```

The relevant models needed to be updated as well. In essence, the `belongs_to` and `has_many` defines the ownership (the relationship)
between the records. The products belong to a user. Also, the `belongs_to` function suffixes the name with `_id` to match the column name
and the `has_many` needs to define the foreign_key if it does not match the default, which in this case would be `user_id`.

> defaults to the underscored name of the current schema suffixed by _id.

In essence, because I'm using foreign key (in the DB) that is not a "standard" - `user_id` - but actually `owner_id` then this customization is necessary. 

```
schema "products" do
    (...)
    belongs_to :owner, DummyProductApi.User
```

```
  schema "users" do
    (...)
    has_many :products, DummyProductApi.Product, foreign_key: :owner_id
```

When executing the code below in a iex session, see how Product has both `owner` and `owner_id`. When we build the association,
the `owner_id` is populated. 

***TODO: when is owner used/populated? does it work if we set the owner and not the owner_id?***
```
alias DummyProductApi.User
{:ok,inserted_user} = %User{} |> User.changeset(%{name: "hugo"}) |> DummyProductApi.Repo.insert()

alias DummyProductApi.Product
new_product = inserted_user |> Ecto.build_assoc(:products, %{name: "bananas", description: "sweet", value: 1})
new_product |> DummyProductApi.Repo.insert()
```

## Renaming columns + more on migrations
if the migration is something simple - like adding a column, then we can just use `change`, but for things even slightly more complex
than that, `up` and `down` provides more control on what it is we want to do.

Renaming a column is simple with `rename` - https://hexdocs.pm/ecto_sql/Ecto.Migration.html#rename/3 - but if we need to rename the foreign keys and underlying indexes, we'll need to drop the constraint to use the DSL. An alternative is to use `execute` to run SQL
commands, which will allow a rename of a constraint.

**NOTE: normally one wouldn't rename a column like this in a production system, but actually make (at least) a 2 step migration with a new column and then remove the old one once everything is moved over**

Naming constraints explicitly can also be a good thing to do, even if it matches the default. This way even if the library changes, or the tool to make migrations changes, the names of the constraints are known and explicit.


## up-to-date iex commands
Leaving previous commands in their versions because they make sense and provide context on the code at the point in time they were created, but they evolve with the changes. So this section just has up-to-date commands

```
alias DummyProductApi.User
{:ok,inserted_user} = %User{} |> User.changeset(%{name: "John Doe"}) |> DummyProductApi.Repo.insert()

alias DummyProductApi.Product
new_product = inserted_user |> Ecto.build_assoc(:products, %{name: "bananas", description: "green", value: 0})
new_product |> DummyProductApi.Repo.insert()
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
