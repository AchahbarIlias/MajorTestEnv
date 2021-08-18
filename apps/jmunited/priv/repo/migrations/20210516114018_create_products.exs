defmodule Jmunited.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :description, :string
      add :size, :integer
      add :color, :string
      add :price, :float

      timestamps()
    end

  end
end
