defmodule Jmunited.Repo.Migrations.CreateCartItems do
  use Ecto.Migration

  def change do
    create table(:cartitems) do
      add :product_id, references(:products, on_delete: :delete_all), null: false
      add :cart_id, references(:carts, on_delete: :delete_all), null: false
      add :amount, :integer, null: false
    end

  end
end
