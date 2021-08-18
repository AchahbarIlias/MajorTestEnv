defmodule Jmunited.ApiContext do
  alias Jmunited.UserContext.User
  alias Jmunited.ApiContext.Api
  alias Jmunited.Repo
  import Ecto.Query, warn: false

  def create_api(attrs, %User{} = user) do
    %Api{}
    |> Api.create_changeset(attrs, user)
    |> Repo.insert()
  end

  def list_apis() do
    query = from x in Api,
    select: x.key
    Repo.all(query)
  end

end