defmodule JmunitedWeb.ProductView do
  use JmunitedWeb, :view

  alias JmunitedWeb.ProductView

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

  def render("index.json", %{products: products}) do
    %{data: render_many(products, ProductView, "product.json")}
  end

  def render("show.json", %{product: product}) do
    %{data: render_one(product, ProductView, "product.json")}
  end

  def render("product.json", %{product: product}) do
    %{id: product.id, name: product.name, price: product.price, size: product.size, color: product.color, description: product.description}
  end
end
