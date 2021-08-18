defmodule Jmunited.CartItemsContext do
  alias Jmunited.ProductContext.Product
  alias Jmunited.CartItemsContext.CartItems
  alias Jmunited.CartContext.Cart
  alias Jmunited.Repo
  import Ecto.Query, warn: false

  def create_cartitems(attrs, %Cart{} = cart, %Product{} = product) do
    %CartItems{}
    |> CartItems.create_changeset(attrs, cart, product)
    |> Repo.insert()
  end

  def create_cartitems_multi(products) do
    Repo.insert_all(CartItems, products)
  end

  def update_cartitems(%CartItems{} = cartitem, attrs) do
    cartitem
    |> CartItems.changeset(attrs)
    |> Repo.update()
  end

  def get_cartitem_by_product(product, user) do
    query = from ci in CartItems,
    join: c in Cart, on: ci.cart_id == c.id,
    where: ci.product_id == ^product.id and c.user_id == ^user.id
    Repo.one(query)
  end

  def delete_cartitem(%CartItems{} = cartitem) do
    Repo.delete(cartitem)
  end

  def empty_cart(userid) do
    query = from c in Cart,
    join: ci in CartItems, on: ci.cart_id == c.id,
    where: c.user_id == ^userid

    Repo.delete_all(query)
  end

end