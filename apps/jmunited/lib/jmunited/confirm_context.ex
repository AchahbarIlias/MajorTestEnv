defmodule Jmunited.ConfirmContext do

  import Ecto.Query, warn: false
  alias Jmunited.Repo

  alias Jmunited.ConfirmContext.Confirm
  alias Jmunited.UserContext.User

  def create_confirm(attrs, %User{} = user) do
    %Confirm{}
    |> Confirm.create_changeset(attrs, user)
    |> Repo.insert()
  end

  def update_confirm(%Confirm{} = confirm, attrs) do
    confirm
    |> Confirm.changeset(attrs)
    |> Repo.update()
  end

  def delete_confirm(%Confirm{} = confirm) do
    Repo.delete(confirm)
  end

  def get_confirm!(id), do: Repo.get!(Confirm, id)

  def get_confirm_by_user_id(user) do
    case Repo.get_by(Confirm, user_id: user) do
      confirm ->
        confirm

      nil ->
        nil
    end
  end

  def get_confirm_by_link(link) do
    case Repo.get_by(Confirm, link: link) do
      confirm ->
        confirm

      nil ->
        nil
    end
  end


end