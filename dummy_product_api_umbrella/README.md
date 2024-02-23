# DummyProductApi.Umbrella

## Database and Ecto schema

### Migrations
See `config.exs` for migration defaults and docs for such options in [here](https://hexdocs.pm/ecto_sql/Ecto.Migration.html#timestamps/1)


#### Use UUIDs as default for primary keys
```
config :dummy_product_api, DummyProductApi.Repo,
  migration_primary_key: [name: :id, type: :binary_id]
```
An update after the fact: `mix phx.new` supports a `--binary-id` option

### Building the initial Product model

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

### Renaming columns + more on migrations
if the migration is something simple - like adding a column, then we can just use `change`, but for things even slightly more complex
than that, `up` and `down` provides more control on what it is we want to do.

Renaming a column is simple with `rename` - https://hexdocs.pm/ecto_sql/Ecto.Migration.html#rename/3 - but if we need to rename the foreign keys and underlying indexes, we'll need to drop the constraint to use the DSL. An alternative is to use `execute` to run SQL
commands, which will allow a rename of a constraint.

**NOTE: normally one wouldn't rename a column like this in a production system, but actually make (at least) a 2 step migration with a new column and then remove the old one once everything is moved over**

Naming constraints explicitly can also be a good thing to do, even if it matches the default. This way even if the library changes, or the tool to make migrations changes, the names of the constraints are known and explicit.

### Querying
Preloading associations will work as such
```
import Ecto.Query, only: [from: 2]
alias DummyProductApi.Product
alias DummyProductApi.User
alias DummyProductApi.Repo

query = from p in Product, select: p, preload: [:owner_user]
query |> Repo.all()
```
This will issue 2 queries:
1. retrieve products
2. retrieve users via user id

Inversely, from users and their products
```
import Ecto.Query, only: [from: 2]
alias DummyProductApi.Product
alias DummyProductApi.User
alias DummyProductApi.Repo

query = from u in User, select: u, preload: [:products]
query |> Repo.all()
```

To retrieve all data with a single query
```
import Ecto.Query, only: [from: 2]
alias DummyProductApi.Product
alias DummyProductApi.User
alias DummyProductApi.Repo

query = from p in Product,
 inner_join: u in assoc(p, :owner_user),
 preload: [owner_user: u]
query |> Repo.all()
```

## Building an API
On a fair note, an API does not need frontend resources, so these types of
projects can be bootstrapped with the following options from `mix phx.new`
`--no-assets --no-html --no-gettext --no-dashboard --no-live --no-mailer`

### Authentication with JWT
[Joken](https://hexdocs.pm/joken/readme.html) 
which pulls JOSE as a dependency to work with JWTs.

A module can be configured with `use Joken.Config` to implement
the necessary functions and wiring to configuration (`config.exs` and relative env configuration).

The configuration itself was a bit difficult to understand, but ultimately a basic
example with a default signer looks like:
```
config :joken,
  default_signer:
    [
      signer_alg: "RS256", # or whatever other algorithm
      key_pem: <private key contents>,
      jose_extra_headers: %{"kid" => "<key ID>"}
    ]
```
A default signer is good IF we don't rotate (private) keys, which is not ideal for security. To rotate keys we need to specify a 
key ID `kid` on the signer which will include that header in generated JWTs. 
A `kid` could be the sha1 (`openssl sha1 <path_to_key>`) of the private key,
but even better of an associated public key which the server should serve on a well known URL. In open ID protocol a 
[provider configuration](https://openid.net/specs/openid-connect-discovery-1_0.html#ProviderConfig) 
is established in a well known URI. This URI response contains a `jwks_uri` which is where the keys should be served.

#### Key rotation
To rotate the keys, multiple signers must be supported (at least the previous and a new signer). 
The JWTs must be validated according to their `kid`. Once the previous signer is removed signing new tokens, some time
must be allowed to pass (at least the TTL of the tokens) so that we can safely remove the old signer 

We can define specific signers in the configuration, but no default signer. Maybe it supports both approaches - default and other signers.
With a default signer, we can generate and verify without passing in the atom identifying the signer to these functions, but we can also 
pass in the explicit signer.

```elixir
# default signer
JWT.generate_and_sign(claims)
# explicit signer
JWT.generate_and_sign(claims, :new_signer)
```

As long as tokens have a `kid` (which they should) then we can match the kid to the signer and apply it in a `before_verify` Joken hook, which would look like:

```elixir
  @impl true
  def before_verify(_hook_options, {token, _signer}) do
    new_signer = Joken.Signer.parse_config(:new_signer)
    new_signer_kid = Joken.Signer.parse_config(:new_signer).jws.fields["kid"]

    old_signer = Joken.Signer.parse_config(:old_signer)
    old_signer_kid = Joken.Signer.parse_config(:old_signer).jws.fields["kid"]

    with {:ok, headers} <- Joken.peek_header(token),
         kid <- Map.get(headers, "kid") do
      case kid do
        ^new_signer_kid ->
          {:cont, {token, new_signer}}

        ^old_signer_kid ->
          {:cont, {token, old_signer}}

        # other key ids are not valid
        nil ->
          Logger.warning("No key id (kid) header present in token")
          @hook_signature_error
        kid ->
          Logger.warning("Key for JWT token not recognized #{kid}")
          @hook_signature_error
      end
    else
      _ -> @hook_signature_error
    end
  end
```

**NOTE: we can access the config file signers via `parse_config` function**

With this setup it would be possible to rotate keys by always maintaining an old and new key. When rotating keys, the "new key" becomes the old_key/old_signer and a newly created key is assigned to be the new_key/new_signer.

#### Create a RSA private key
`openssl genrsa -out <private_key_path> 2048`

#### Retrieve a public key from a RSA key
`openssl rsa -in <private_key_path> -pubout > <public_key_path>`

#### SHA1 of a file
openssl sha1 <filepath>



### *More Coming soon*


## TODO
- Build authenticated endpoints with JWT as bearer tokens
  - issuing of JWT tokens as access tokens. Could also do ID tokens but necessary for this
  - validating JWT tokens signature
  - protect endpoints with JWT when authN/Z is required
- Build an API for users (with tests)
- Build an API for products (with tests)
- test fixtures - https://blog.appsignal.com/2023/02/28/an-introduction-to-test-factories-and-fixtures-for-elixir.html 
- Run as docker container
- Get telemetry/metrics using a prometheus exporter
  - https://github.com/deadtrickster/prometheus-phoenix
  - (a bit more low level) https://github.com/deadtrickster/prometheus.ex
- (?) Authentication with JWT
- (?) Dumb down "backoffice" frontend to display users and products



## up-to-date iex commands
Leaving previous commands in their versions because they make sense and provide context on the code at the point in time they were created, but they evolve with the changes. So this section just has up-to-date commands

```
alias DummyProductApi.User
{:ok,inserted_user} = %User{} |> User.changeset(%{name: "John Doe"}) |> DummyProductApi.Repo.insert()

alias DummyProductApi.Product
new_product = inserted_user |> Ecto.build_assoc(:products, %{name: "bananas", description: "green", value: 0})
new_product |> DummyProductApi.Repo.insert()
```

## Multiple tests environments/levels
Based on this guide https://spin.atomicobject.com/2018/10/22/elixir-test-multiple-environments/

The main aspect to record is that I tried to use `:unit_test` (and not `:test`) alongside `:integration_test`,
which didn't work quite well. I wanted to use `mix test` to run all tests.
However `mix test` runs with `test` environment so everything got confused and
tests would error out with dependent applications not being started. However, setting the appropriate env
with `MIX_ENV=<unit|integration_test>` worked fine.

It might be possible to set up a task/alias to run all tests for all environments. In this
way it could be possible to run all tests together, but at the same time I wonder if `mix test`
would become a "standard" command that is unused and when used it would break - does not seem great to me.
Likely there's some way to address this.

### A different (perhaps better) approach using tags/filters
The multiple env approach was used and reverted. Go back to revision `67f9c6e2c94374e5b2513df82c26ec9959395946`
to see the state of such setup.

Another identified alternative is to use ExUnit tags and filters to run groups
of tests. Here's my perspective on this approach.
- while this still requires the diff tests groups to have the same setup (db, http clients, ...)
we can run tests in a separate manner and with the simpler original setup.
- setting up the stubs/mocks require a bit more work. Instead of defining them in
`test_helper.exs`, which is shared by all test types (meaning it would mess up integration tests), 
a common setup can be used for unit tests, where the same "replacement" 
is done. 
While this is not optimal, it's a single line of code per test module 
and allows chaining of `setup` steps - see [docs](https://hexdocs.pm/ex_unit/1.12/ExUnit.Callbacks.html)

Some further ideas from the internet to explore
- https://www.livinginthepast.org/blog/exunit-tags-test-setup/
- https://elixirforum.com/t/separate-mix-commands-for-unit-and-integration-tests/32370


## Performance considerations

### Ecto
To see the queries issued by ecto, we can set logging to debug in the appropriate config file - likely 
`dev.exs` and/or `test.exs`. In case of tests the output gets quite verbose

```
config :logger, level: :debug
```

### TO REMOVE :point_down: ONCE THINGS ARE PROPER

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

