defmodule JmunitedWeb.ErrorHandler do
  import Plug.Conn
  use JmunitedWeb, :controller

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    conn
    |> put_flash(:error, "You are not logged in. Please log in to access the features.")
    |> redirect(to: "/login")
  end
end
