defmodule DummyProductApi.Product do
  use DummyProductApi.BaseModel

  import Ecto.Changeset

  schema "products" do
    field :description, :string
    field :name, :string
    field :value, :integer

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :value])
    |> validate_required([:name, :description, :value])
  end
end
