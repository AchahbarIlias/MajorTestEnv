defmodule Jmunited.OrderContext.Order do
  use Ecto.Schema
  import Ecto.Changeset
  alias Jmunited.UserContext.User
  alias Jmunited.OrderedItemsContext.OrderedItems

  schema "orders" do
    field :zip, :integer
    field :city, :string
    field :street, :string
    field :bus, :string
    field :number, :string
    field :returned, :boolean, default: false
    belongs_to :user, User
    has_many :ordereditems, OrderedItems

    timestamps()
  end

  def create_changeset(order, attrs, user) do
    order
    |> cast(attrs, [:zip, :city, :street, :bus, :number])
    |> validate_required([:zip, :city, :street, :number])
    |> put_assoc(:user, user)
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:zip, :city, :street, :bus, :number, :returned])
    |> validate_required([:zip, :city, :street, :number, :returned])
  end

  def update_changeset(order, attrs) do
    order
    |> cast(attrs, [:zip, :city, :street, :bus, :number, :returned])
    |> validate_required([:zip, :city, :street, :number, :returned])
  end
end
