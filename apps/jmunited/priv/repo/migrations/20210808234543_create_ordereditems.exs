defmodule Jmunited.Repo.Migrations.CreateOrderedItems do
  use Ecto.Migration

  def change do
    create table(:ordereditems) do
      add :product_id, references(:products, on_delete: :delete_all), null: false
      add :order_id, references(:orders, on_delete: :delete_all), null: false
      add :amount, :integer, null: false
    end

  end
end
