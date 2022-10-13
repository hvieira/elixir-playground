defmodule DummyProductApi.Repo.Migrations.RenameOwnerColumn do
  use Ecto.Migration

  def up do
    drop constraint("products", "products_owner_id_fkey")
    rename table("products"), :owner_id, to: :owner_user_id

    alter table("products") do
      modify :owner_user_id, references("users", type: :binary_id, column: "id"),
        null: false,
        name: "products_owner_user_id_fkey"
    end
  end

  def down do
    drop constraint("products", "products_owner_user_id_fkey")
    rename table("products"), :owner_user_id, to: :owner_id

    alter table("products") do
      modify :owner_id, references("users", type: :binary_id, column: "id"), null: false
    end
  end
end
