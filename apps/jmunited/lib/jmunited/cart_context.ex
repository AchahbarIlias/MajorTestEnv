defmodule Jmunited.CartContext do
  @moduledoc """
  The CartContext context.
  """

  import Ecto.Query, warn: false
  alias Jmunited.Repo

  alias Jmunited.CartContext.Cart
  alias Jmunited.CartItemsContext.CartItems
  alias Jmunited.UserContext.User
  alias Jmunited.ProductContext.Product

  @doc """
  Returns the list of carts.

  ## Examples

      iex> list_carts()
      [%Cart{}, ...]

  """
  def list_carts do
    Repo.all(Cart)
  end

  @doc """
  Gets a single cart.

  Raises `Ecto.NoResultsError` if the Cart does not exist.

  ## Examples

      iex> get_cart!(123)
      %Cart{}

      iex> get_cart!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cart!(id), do: Repo.get!(Cart, id)

  @doc """
  Creates a cart.

  ## Examples

      iex> create_cart(%{field: value})
      {:ok, %Cart{}}

      iex> create_cart(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cart(attrs \\ %{}, %User{} = user) do
    %Cart{}
    |> Cart.changeset(attrs, user)
    |> Repo.insert()
  end

  @doc """
  Updates a cart.

  ## Examples

      iex> update_cart(cart, %{field: new_value})
      {:ok, %Cart{}}

      iex> update_cart(cart, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cart(%Cart{} = cart, attrs) do
    cart
    |> Cart.update_changeset(attrs)
    |> Repo.update()
  end

  def get_cart_by_user(user) do
    case Repo.get_by(Cart, user_id: user.id) do
      cart ->
        cart
      end
  end

  def has_cart(userid) do
    query = from c in Cart,
    where: c.user_id == ^userid,
    select: c.user_id
    Repo.aggregate(query, :count)
  end

  def cart_amount_by_user(userid, productid) do
    query = from ci in CartItems,
    join: c in Cart, on: ci.cart_id == c.id,
    where: c.user_id == ^userid and ci.product_id == ^productid,
    select: ci.amount
    Repo.one(query)
  end

  def cart_by_product_user(userid, productid) do
    query = from c in Cart,
    join: ci in CartItems, on: c.id == ci.cart_id,
    where: c.user_id == ^userid and ci.product_id == ^productid
    Repo.one(query)
  end

  def products_by_user(userid, orderid) do
    query = from c in Cart,
    join: ci in CartItems, on: ci.cart_id == c.id,
    join: p in Product, on: p.id == ci.product_id,
    where: c.user_id == ^userid,
    select: %{product_id: p.id, amount: ci.amount ,order_id: ^orderid}
    Repo.all(query)
  end

  def totalPrice(userid) do
    query2 = from pp in subquery(
      from o in Cart,
      join: oi in CartItems, on: o.id == oi.cart_id,
      join: p in Product, on: p.id == oi.product_id,
      where: o.user_id == ^userid,
      select: %{total_price: fragment("(amount * price)")}
    ),
    select: sum(pp.total_price)
    totalPrice = Repo.one(query2)

  end

  def cart_by_user(userid) do
  query = from c in Cart,
    join: ci in CartItems, on: ci.cart_id == c.id,
    join: p in Product, on: p.id == ci.product_id,
    where: c.user_id == ^userid,
    select: %{id: p.id, color: p.color, description: p.description, name: p.name, price: p.price, size: p.size, amount: ci.amount, total_price: fragment("(amount * price)")}
    Repo.all(query)
  end

  def get_price_by_user(userid) do
#     SELECT sum(total_price) FROM (SELECT  p.id, p.color, p.description, p.name, p.price, p.size, c.amount, (c.amount
# * p.price) AS "total_price" FROM products as p inner join carts as c ON(c.product_id = p.id) WHERE c.user_id = ?) as p;
    query = from p in subquery(
      from ci in CartItems,
      join: c in Cart, on: c.user_id == ci.cart_id,
      join: p in Product, on: ci.cart_id == p.id,
      where: c.user_id == ^userid,
      select: %{total_price: fragment("(amount * price)")}
    ),
    select: sum(p.total_price)
    Repo.one(query)
  end

  @doc """
  Deletes a cart.

  ## Examples

      iex> delete_cart(cart)
      {:ok, %Cart{}}

      iex> delete_cart(cart)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cart(%Cart{} = cart) do
    Repo.delete(cart)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cart changes.

  ## Examples

      iex> change_cart(cart)
      %Ecto.Changeset{data: %Cart{}}

  """
  def change_cart(%Cart{} = cart, attrs \\ %{}) do
    Cart.changeset(cart, attrs)
  end

  def order(userid) do
    time = NaiveDateTime.utc_now()
    from(c in Cart,
    where: c.user_id == ^userid and c.ordered == false)
    |> Repo.update_all(set: [ordered: true, updated_at: time])

    # select product_id from carts where user_id = 1 AND updated_at = "2021-05-18 10:32:33")
    query = from p in Product,
    join: c in Cart, on: c.product_id == p.id,
    where: c.user_id == ^userid and c.ordered == true and c.updated_at == ^time,
    select: %{id: p.id, color: p.color, description: p.description, name: p.name, price: p.price, size: p.size, amount: c.amount, total_price: fragment("(amount * price)")}
    products = Repo.all(query)

    query2 = from p in subquery(
      from p in Product,
      join: c in Cart, on: c.product_id == p.id,
      where: c.user_id == ^userid and c.ordered == true and c.updated_at == ^time,
      select: %{total_price: fragment("(amount * price)")}
    ),
    select: sum(p.total_price)
    totalPrice = Repo.one(query2)

    %{:products => products, :totalPrice => totalPrice}

  end

  def history(userid) do
    query = from p in Product,
    join: c in Cart, on: c.product_id == p.id,
    where: c.user_id == ^userid and c.ordered == true,
    select: %{id: p.id, color: p.color, description: p.description, name: p.name, price: p.price, size: p.size, amount: c.amount, total_price: fragment("(amount * price)"), updated_at: c.updated_at}
    Repo.all(query)
  end
end
