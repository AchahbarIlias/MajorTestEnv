defmodule JmunitedWeb.CartController do
  use JmunitedWeb, :controller

  alias Jmunited.CartContext
  alias Jmunited.CartContext.Cart
  alias Jmunited.ProductContext
  alias JmunitedWeb.Email
  alias JmunitedWeb.Mailer
  alias Jmunited.ApiContext
  alias Jmunited.CartItemsContext
  alias Jmunited.CartItemsContext.CartItems
  require Logger

  action_fallback JmunitedWeb.FallbackController

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    products = CartContext.cart_by_user(user.id)
    price = CartContext.totalPrice(user.id)
    render(conn, "index.html", products: products, price: price)
  end

  def create(conn, %{"productid" => productid, "amount" => amount}) do
    user = Guardian.Plug.current_resource(conn)
    product = ProductContext.get_product!(productid)
    amountProducts = CartContext.has_cart(user.id)

    if amountProducts == nil || amountProducts == 0 do
      with {:ok, cart} <- CartContext.create_cart(user) do

        CartItemsContext.create_cartitems(%{:amount => amount}, cart, product)
        conn
        |> put_flash(:info, "Product added to cart.")
        |> redirect(to: Routes.cart_path(conn, :index))
      end
    else
      cart = CartContext.get_cart_by_user(user)
      newAmount = amountProducts + String.to_integer(amount)

      CartItemsContext.create_cartitems(%{:amount => amount}, cart, product)

        conn
        |> put_flash(:info, "Product added to cart.")
        |> redirect(to: Routes.cart_path(conn, :index))
      
    end
  end

  def update(conn, %{"productid" => productid, "amount" => amount}) do
    user = Guardian.Plug.current_resource(conn)
    product = ProductContext.get_product!(productid)
    cartitem = CartItemsContext.get_cartitem_by_product(product, user)
    
    if(String.to_integer(amount) > 0) do
      with {:ok, _cart} <- CartItemsContext.update_cartitems(cartitem, %{:amount => amount}) do
        conn
        |> put_flash(:info, "Amount changed.")
        |> redirect(to: Routes.cart_path(conn, :index))
      end
    else

      with {:ok, %CartItems{}} <- CartItemsContext.delete_cartitem(cartitem) do
        conn
        |> put_flash(:info, "Amount changed, item deleted from cart.")
        |> redirect(to: Routes.cart_path(conn, :index))
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    cart = CartContext.get_cart!(id)

    with {:ok, %Cart{}} <- CartContext.delete_cart(cart) do
      send_resp(conn, :no_content, "")
    end
  end

  def order(conn, _params) do
    conn
    |> redirect(to: Routes.order_path(conn, :new))
  end

  def history(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    products = CartContext.history(user.id)
    render(conn, "history.html", products: products)
  end

  def cart(conn, %{"id" => id}) do
    key = Enum.at(get_req_header(conn, "webshop-api-key"), 0)
    apis = ApiContext.list_apis()
    if(Enum.member?(apis, key)) do
      cart = CartContext.history(id)
      render(conn, "show.json", cart: cart)
    else
      conn
        |> send_resp(400, "You have not entered an API key or have a wrong API key.")
    end
  end
end
