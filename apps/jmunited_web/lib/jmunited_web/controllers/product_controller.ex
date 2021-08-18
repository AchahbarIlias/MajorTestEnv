defmodule JmunitedWeb.ProductController do
  use JmunitedWeb, :controller

  alias Jmunited.ProductContext
  alias Jmunited.ProductContext.Product
  alias CSV


  def index(conn, _params) do
    products = ProductContext.list_products()
    render(conn, "index.html", products: products)
  end


  def new(conn, _params) do
    changeset = ProductContext.change_product(%Product{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"product" => product_params}) do
    case ProductContext.create_product(product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product created successfully.")
        |> redirect(to: Routes.product_path(conn, :show, product))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    product = ProductContext.get_product!(id)
    render(conn, "show.html", product: product)
  end

  def edit(conn, %{"id" => id}) do
    product = ProductContext.get_product!(id)
    changeset = ProductContext.change_product(product)
    render(conn, "edit.html", product: product, changeset: changeset)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = ProductContext.get_product!(id)

    case ProductContext.update_product(product, product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product updated successfully.")
        |> redirect(to: Routes.product_path(conn, :show, product))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", product: product, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = ProductContext.get_product!(id)
    {:ok, _product} = ProductContext.delete_product(product)

    conn
    |> put_flash(:info, "Product deleted successfully.")
    |> redirect(to: Routes.product_path(conn, :index))
  end

  def filter(conn, %{"property" => property, "value" => value}) do 
    case ProductContext.filter(property, value) do
    {:ok, products} ->
      render(conn, "index.html", products: products)
    
    {:error, _error} -> 
      conn
        |> put_flash(:error, "Your search contained some errors.")
        |> redirect(to: Routes.product_path(conn, :index))
    end
    # products = ProductContext.filter(property, value)
    # render(conn, "index.html", products: products)
  end


  def indexjson(conn, _param) do
    products = ProductContext.list_products()
    render(conn, "index.json", products: products)
  end

  def showjson(conn, %{"id" => id}) do
    product = ProductContext.get_product!(id)
    render(conn, "show.json", product: product)
  end
end
