defmodule JmunitedWeb.UserView do
  use JmunitedWeb, :view

  alias JmunitedWeb.UserView

  def isAdmin(conn) do
    user = Guardian.Plug.current_resource(conn);
    if user.role == "Admin" do
      true
    else
      false
    end
  end

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, email: user.email, role: user.role, confirmed: user.confirmed, first_name: user.first_name, last_name: user.last_name, country: user.country, city: user.city, zip: user.zip, street: user.street, number: user.number}
  end
end
