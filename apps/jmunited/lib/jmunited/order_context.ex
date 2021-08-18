defmodule Jmunited.OrderContext do
  alias Jmunited.UserContext.User
  alias Jmunited.OrderContext.Order
  alias Jmunited.Repo
  alias Jmunited.CartContext.Cart
  alias Jmunited.ProductContext.Product
  alias Jmunited.OrderedItemsContext.OrderedItems
  import Ecto.Query, warn: false

  def create_order(attrs, %User{} = user) do
    %Order{}
    |> Order.create_changeset(attrs, user)
    |> Repo.insert()
  end

  def change_order(%Order{} = order, attrs \\ %{}) do
    Order.changeset(order, attrs)
  end

  def totalPrice(orderid) do
    query2 = from pp in subquery(
      from oi in OrderedItems,
      join: p in Product, on: p.id == oi.product_id,
      where: oi.order_id == ^orderid,
      select: %{total_price: fragment("(amount * price)")}
    ),
    select: sum(pp.total_price)
    totalPrice = Repo.one(query2)

  end

  def orderedProducts(orderid) do
    query = from oi in OrderedItems,
    join: p in Product, on: p.id == oi.product_id,
    where: oi.order_id == ^orderid,
    select: %{id: p.id, color: p.color, description: p.description, name: p.name, price: p.price, size: p.size, amount: oi.amount, total_price: fragment("(amount * price)")}
    Repo.all(query)
  end

  def orderHistory(userid) do
    query = from o in Order,
    where: o.user_id == ^userid and o.returned == false,
    select: o

    Repo.all(query)
  end

  def is_order_from_user(orderid, userid) do
    query = from o in Order,
    where: o.id == ^orderid and o.user_id == ^userid,
    select: count()
    Repo.all(query)
  end

  def get_order_by_orderid(orderid) do
    case Repo.get_by(Order, id: orderid) do
      order ->
        order
      end
  end

  def retourOrder(order, attrs) do
    Order.changeset(order, attrs)
    |> Repo.update()
  end

  def allRetours(userid) do
    query = from o in Order,
    where: o.user_id == ^userid and o.returned == true,
    select: o

    Repo.all(query)
  end

end