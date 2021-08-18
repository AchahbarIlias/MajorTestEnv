defmodule JmunitedWeb.ApiController do
  use JmunitedWeb, :controller
  alias Jmunited.ApiContext
  alias Jmunited.UserContext
  require Logger

  def generate(conn, params) do
    key = Randomizer.randomizer(20)
    user = Guardian.Plug.current_resource(conn)
    
    with {:ok, api} <- ApiContext.create_api(%{:key => key}, user) do
      conn
      |> put_flash(:info, "Your API key is: `#{api.key}`. Don't lose it!")
      |> redirect(to: Routes.profile_path(conn, :profile))
    end
  end
end