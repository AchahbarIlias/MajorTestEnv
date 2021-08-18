defmodule JmunitedWeb.ProfileController do
  use JmunitedWeb, :controller

  alias JmunitedWeb.Guardian
  alias Jmunited.UserContext

  def profile(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    render(conn, "profile.html", user: user)
  end

  def edit(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    changeset = UserContext.change_user(user)

    render(conn, "form.html",
      user: user,
      changeset: changeset,
      action: Routes.profile_path(conn, :editprofile)
    )
  end

  def editprofile(conn, %{"user" => user_params}) do
    user = Guardian.Plug.current_resource(conn)

    case UserContext.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.profile_path(conn, :profile))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "profile.html", user: user, changeset: changeset)
    end
  end
end