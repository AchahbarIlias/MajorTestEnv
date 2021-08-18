defmodule Jmunited.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :zip, :integer
      add :city, :string
      add :street, :string
      add :bus, :string
      add :number, :string
      add :returned, :boolean, default: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end
