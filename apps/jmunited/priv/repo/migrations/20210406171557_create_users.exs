defmodule Jmunited.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :country, :string
      add :city, :string
      add :zip, :integer
      add :street, :string
      add :number, :integer
      add :hashed_password, :string
      add :role, :string
      add :confirmed, :boolean

      timestamps()
    end
    create unique_index(:users, [:email])
  end
end
