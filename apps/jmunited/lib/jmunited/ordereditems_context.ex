defmodule Jmunited.OrderedItemsContext do
  alias Jmunited.ProductContext.Product
  alias Jmunited.OrderedItemsContext.OrderedItems
  alias Jmunited.OrderContext.Order
  alias Jmunited.Repo
  import Ecto.Query, warn: false

  def create_ordereditem(attrs, %Product{} = product, %Order{} = order) do
    %OrderedItems{}
    |> OrderedItems.create_changeset(attrs, product, order)
    |> Repo.insert()
  end

  def create_ordereditems_multi(products) do
    Repo.insert_all(OrderedItems, products)
  end

end