defmodule DummyProductApi.User do
  use DummyProductApi.BaseModel

  import Ecto.Changeset

  schema "users" do
    field :name, :string
    has_many :products, DummyProductApi.Product, foreign_key: :owner_user_id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
