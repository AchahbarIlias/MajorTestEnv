defmodule JmunitedWeb.LayoutView do
  use JmunitedWeb, :view

  def isLoggedin(conn) do
    user = Guardian.Plug.current_resource(conn);
    if user do
      true
    else
      false
    end
  end

  def isAdmin(conn) do
    user = Guardian.Plug.current_resource(conn);
    if user.role == "Admin" do
      true
    else
      false
    end
  end

  def new_locale(conn, locale, language_title) do
    "<a href=\"#{Routes.page_path(conn, :index, locale: locale)}\">#{language_title}</a>" |> raw
  end
end
