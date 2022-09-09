defmodule DummyProductApi.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :description, :string
      add :value, :integer

      timestamps()
    end
  end
end
