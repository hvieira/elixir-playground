defmodule DummyProductApi.User do
  use DummyProductApi.BaseModel

  import Ecto.Changeset

  schema "users" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
