defmodule DummyProductApi.Product do
  use DummyProductApi.BaseModel

  import Ecto.Changeset

  schema "products" do
    field :description, :string
    field :name, :string
    field :value, :integer
    belongs_to :owner_user, DummyProductApi.User

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :value])
    |> cast_assoc(:owner_user)
    |> validate_required([:name, :description, :value])
  end
end
