defmodule Jmunited.OrderedItemsContext.OrderedItems do
  use Ecto.Schema
  import Ecto.Changeset
  alias Jmunited.OrderContext.Order
  alias Jmunited.ProductContext.Product

  schema "ordereditems" do
    belongs_to :product, Product
    belongs_to :order, Order
    field :amount, :integer
  end

  def create_changeset(ordereditems, attrs, product, order) do
    ordereditems
    |> cast(attrs, [:amount])
    |> validate_required([:amount])
    |> put_assoc(:order, order)
    |> put_assoc(:product, product)
  end

  @doc false
  def changeset(ordereditems, attrs) do
    ordereditems
    |> cast(attrs, [:amount])
    |> validate_required([:amount])
  end
end
