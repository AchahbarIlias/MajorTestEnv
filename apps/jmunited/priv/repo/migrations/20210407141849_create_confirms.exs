defmodule Jmunited.Repo.Migrations.CreateConfirms do
  use Ecto.Migration

  def change do
    create table(:confirms) do
      add :link, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:confirms, [:user_id])
  end
end
