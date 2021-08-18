defmodule Jmunited.ConfirmContext.Confirm do
  use Ecto.Schema
  import Ecto.Changeset
  alias Jmunited.UserContext.User


  schema "confirms" do
    field :link, :string
    belongs_to :user, User

    timestamps(type: :naive_datetime)
  end

  def create_changeset(confirm, attrs, user) do
    confirm
    |> cast(attrs, [:link])
    |> validate_required([:link])
    |> put_assoc(:user, user)
  end

  @doc false
  def changeset(confirm, attrs) do
    confirm
    |> cast(attrs, [:link])
    |> validate_required([:link])
  end
end
