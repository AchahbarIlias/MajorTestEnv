defmodule JmunitedWeb.PageController do
  use JmunitedWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
