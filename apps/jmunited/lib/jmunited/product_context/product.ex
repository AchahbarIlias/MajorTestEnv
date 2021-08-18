defmodule Jmunited.ProductContext.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :color, :string
    field :description, :string
    field :name, :string
    field :price, :float
    field :size, :integer

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :size, :color, :price])
    |> validate_required([:name, :description, :size, :color, :price])
  end
end