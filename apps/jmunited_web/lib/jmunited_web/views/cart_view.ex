defmodule JmunitedWeb.CartView do
  use JmunitedWeb, :view
  
  alias JmunitedWeb.CartView

  def isAdmin(conn) do
    user = Guardian.Plug.current_resource(conn);
    if user.role == "Admin" do
      true
    else
      false
    end
  end

  def isLoggedin(conn) do
    user = Guardian.Plug.current_resource(conn);
    if user do
      true
    else
      false
    end
  end

  def render("show.json", %{cart: cart}) do
    %{data: render_many(cart, CartView, "cart.json")}
  end

  def render("cart.json", %{cart: cart}) do
    %{id: cart.id, name: cart.name, price: cart.price, size: cart.size, color: cart.color, description: cart.description, amount: cart.amount, total_price: cart.total_price}
  end
end
