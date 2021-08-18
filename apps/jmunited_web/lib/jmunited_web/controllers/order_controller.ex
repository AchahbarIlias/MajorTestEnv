defmodule JmunitedWeb.OrderController do
  use JmunitedWeb, :controller

  alias Jmunited.OrderContext
  alias Jmunited.OrderContext.Order
  alias Jmunited.OrderedItemsContext
  alias Jmunited.OrderedItemsContext.OrderedItems
  alias Jmunited.CartContext.Cart
  alias Jmunited.CartContext
  alias JmunitedWeb.Email
  alias JmunitedWeb.Mailer
  alias Jmunited.CartItemsContext

  action_fallback JmunitedWeb.FallbackController

  def new(conn, _params) do
    changeset = OrderContext.change_order(%Order{})
    render(conn, "new.html", changeset: changeset)
  end

  def order(conn, %{"order" => order_params}) do
    user = Guardian.Plug.current_resource(conn)
    case OrderContext.create_order(order_params, user) do
      {:ok, order} -> 
        products = OrderContext.orderedProducts(order.id)

        productsToOrder = CartContext.products_by_user(user.id, order.id);
        OrderedItemsContext.create_ordereditems_multi(productsToOrder)

        CartItemsContext.empty_cart(user.id)

        totalPrice = OrderContext.totalPrice(order.id)
        Email.order_confirmation(user.email, products, totalPrice)
        |> Mailer.deliver_now!()

        conn
        |> put_flash(:info,"Products succesfully ordered. You have received a confirmation mail at #{user.email}")
        |> redirect(to: Routes.cart_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
    
  end

  def history(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    orders = OrderContext.orderHistory(user.id)
    render(conn, "history.html", orders: orders)
  end

  def show(conn, %{"orderid" => orderid}) do
    user = Guardian.Plug.current_resource(conn)
    isValid = OrderContext.is_order_from_user(orderid, user.id)
    if Enum.at(isValid, 0) == 0 do
      conn
        |> put_flash(:error,"You do not have acces to this order.")
        |> redirect(to: Routes.order_path(conn, :history))
    else
      products = OrderContext.orderedProducts(orderid)
      render(conn, "show.html", products: products, orderid: orderid)
    end
    
  end

  def retour(conn, %{"orderid" => orderid}) do
    user = Guardian.Plug.current_resource(conn)
    order = OrderContext.get_order_by_orderid(orderid)
    OrderContext.retourOrder(order, %{returned: true})

    products = OrderContext.orderedProducts(order.id)

    productsToOrder = CartContext.products_by_user(user.id, order.id);
    OrderedItemsContext.create_ordereditems_multi(productsToOrder)

    CartItemsContext.empty_cart(user.id)

    totalPrice = OrderContext.totalPrice(order.id)
    Email.retour_confirmation(user.email, products, totalPrice)
    |> Mailer.deliver_now!()

    conn
    |> redirect(to: Routes.order_path(conn, :history))
  end


  def retourlist(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    orders = OrderContext.allRetours(user.id)
    render(conn, "retours.html", orders: orders)
  end

  def cancel(conn, %{"orderid" => orderid}) do
    user = Guardian.Plug.current_resource(conn)
    order = OrderContext.get_order_by_orderid(orderid)
    OrderContext.retourOrder(order, %{returned: false})

    conn
    |> redirect(to: Routes.order_path(conn, :history))
  end

end
