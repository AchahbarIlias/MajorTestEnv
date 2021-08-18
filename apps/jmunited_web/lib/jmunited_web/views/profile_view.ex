defmodule JmunitedWeb.ProfileView do
  use JmunitedWeb, :view

  def isAdmin(conn) do
    user = Guardian.Plug.current_resource(conn);
    if user.role == "Admin" do
      true
    else
      false
    end
  end
end
