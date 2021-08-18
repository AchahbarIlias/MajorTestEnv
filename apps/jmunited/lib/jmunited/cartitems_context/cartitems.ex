defmodule Jmunited.CartItemsContext.CartItems do
  use Ecto.Schema
  import Ecto.Changeset

  alias Jmunited.UserContext.User
  alias Jmunited.CartContext.Cart
  alias Jmunited.ProductContext.Product

  schema "cartitems" do
    belongs_to :cart, Cart
    belongs_to :product, Product
    field :amount, :integer
  end

  def create_changeset(cartitems, attrs, cart, product) do
    cartitems
    |> cast(attrs, [:amount])
    |> validate_required([:amount])
    |> put_assoc(:cart, cart)
    |> put_assoc(:product, product)
  end

  @doc false
  def changeset(cartitems, attrs) do
    cartitems
    |> cast(attrs, [:amount])
    |> validate_required([:amount])
  end
end
