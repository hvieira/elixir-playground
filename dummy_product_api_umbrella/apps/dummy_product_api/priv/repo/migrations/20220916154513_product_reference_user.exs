defmodule DummyProductApi.Repo.Migrations.ProductReferenceUser do
  use Ecto.Migration

  def change do
    alter table("products") do
      add :owner_id, references("users", type: :binary_id, column: "id"), null: false
    end
  end
end
