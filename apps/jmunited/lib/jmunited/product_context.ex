defmodule Jmunited.ProductContext do
  require Logger
  @moduledoc """
  The ProductContext context.
  """

  import Ecto.Query, warn: false
  alias Jmunited.Repo

  alias Jmunited.ProductContext.Product

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Repo.all(Product)
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id), do: Repo.get!(Product, id)

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  def filter(property, value) do
    query = case property do
      "name" -> name = "%#{value}%"
        query = from p in Product,
        where: like(p.name, ^name) 
      "size" -> 
        query = from p in Product,
        where: p.size == type(^value, :integer)
      "color" -> query = from p in Product,
        where: p.color == ^value
      "minprice" -> 
        query = from p in Product,
        where: p.price >= type(^value, :integer)
      "maxprice" -> query = from p in Product,
        where: p.price <= type(^value, :integer)
    end
    try do
      {:ok, Repo.all(query)}
    rescue 
      e in Ecto.Query.CastError -> {:error, e}
    end
  end
end
