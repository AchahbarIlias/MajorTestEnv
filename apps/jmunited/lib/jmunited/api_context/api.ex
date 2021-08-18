defmodule Jmunited.ApiContext.Api do
  use Ecto.Schema
  import Ecto.Changeset
  alias Jmunited.UserContext.User

  schema "apis" do
    field :key, :string
    belongs_to :user, User

    timestamps()
  end

  def create_changeset(api, attrs, user) do
    api
    |> cast(attrs, [:key])
    |> validate_required([:key])
    |> put_assoc(:user, user)
  end

  @doc false
  def changeset(api, attrs) do
    api
    |> cast(attrs, [:apis, :key])
    |> validate_required([:apis, :key])
  end
end
