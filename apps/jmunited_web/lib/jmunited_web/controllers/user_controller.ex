defmodule JmunitedWeb.UserController do
  use JmunitedWeb, :controller

  alias Jmunited.UserContext
  alias Jmunited.UserContext.User
  alias Jmunited.ApiContext
  require Logger

  def index(conn, _params) do
    users = UserContext.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = UserContext.change_user(%User{})
    roles = UserContext.get_acceptable_roles()
    render(conn, "new.html", changeset: changeset, acceptable_roles: roles)
  end

  def create(conn, %{"user" => user_params}) do
    user_params_new = Map.put(user_params, "confirmed", true)
    case UserContext.create_user(user_params_new) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        roles = UserContext.get_acceptable_roles
        render(conn, "new.html", changeset: changeset, acceptable_roles: roles)
    end
  end

  def show(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    changeset = UserContext.change_user(user)
    roles = UserContext.get_acceptable_roles()
    render(conn, "edit.html", user: user, changeset: changeset, acceptable_roles: roles)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = UserContext.get_user!(id)

    case UserContext.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = UserContext.get_user!(id)

    case UserContext.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    {:ok, _user} = UserContext.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end

  def users(conn, _param) do
    key = Enum.at(get_req_header(conn, "webshop-api-key"), 0)
    apis = ApiContext.list_apis()
    if(Enum.member?(apis, key)) do
      users = UserContext.list_users()
      render(conn, "index.json", users: users)
    else
      conn
        |> send_resp(400, "You have not entered an API key or have a wrong API key.")
    end
  end

  def user(conn, %{"id" => id}) do
    key = Enum.at(get_req_header(conn, "webshop-api-key"), 0)
    apis = ApiContext.list_apis()
    if(Enum.member?(apis, key)) do
      user = UserContext.get_user(id)
    render(conn, "show.json", user: user)
    else
      conn
        |> send_resp(400, "You have not entered an API key or have a wrong API key.")
    end
  end
end
