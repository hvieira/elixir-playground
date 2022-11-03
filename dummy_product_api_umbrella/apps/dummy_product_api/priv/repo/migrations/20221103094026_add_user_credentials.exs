defmodule DummyProductApi.Repo.Migrations.AddUserCredentials do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :username, :string, null: false
      add :password, :string, null: false
    end
  end
end
