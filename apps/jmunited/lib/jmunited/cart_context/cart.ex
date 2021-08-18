defmodule Jmunited.CartContext.Cart do
  use Ecto.Schema
  import Ecto.Changeset

  alias Jmunited.UserContext.User
  alias Jmunited.ProductContext.Product
  alias Jmunited.CartItemsContext.CartItems

  schema "carts" do
    belongs_to :user, User
    has_many :cartitems, CartItems

    timestamps()
  end

  @doc false
  def changeset(cart, attrs, user) do
    cart
    |> cast(attrs, [])
    |> validate_required([])
    |> put_assoc(:user, user)
  end

  def update_changeset(cart, attrs) do
    cart
    |> cast(attrs, [:amount])
    |> validate_required([:amount])
  end
end
