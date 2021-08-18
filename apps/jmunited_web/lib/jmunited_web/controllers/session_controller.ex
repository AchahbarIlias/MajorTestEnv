defmodule JmunitedWeb.SessionController do
  use JmunitedWeb, :controller

  alias JmunitedWeb.Guardian
  alias Jmunited.UserContext
  alias Jmunited.UserContext.User
  alias Jmunited.ConfirmContext
  alias JmunitedWeb.Email
  alias JmunitedWeb.Mailer
  require Logger

  def new(conn, _) do
    changeset = UserContext.change_user(%User{})
    current_user = Guardian.Plug.current_resource(conn)

    if current_user do
      redirect(conn, to: "/")
    else
      render(conn, "login.html", changeset: changeset, action: Routes.session_path(conn, :login))
    end
  end

  def login(conn, %{"user" => %{"email" => email, "password" => password}}) do
    UserContext.authenticate_user(email, password)
    |> login_reply(conn)
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/login")
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:info, "Welcome back!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/")
  end

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_flash(:error, "Email or password is incorrect.")
    |> new(%{})
  end

  def showSignup(conn,_) do
      changeset = UserContext.change_user(%User{})
      roles = ["User"]
      render(conn, "signup.html", changeset: changeset, acceptable_roles: roles, action: Routes.session_path(conn, :signup))
  end

  def signup(conn, %{"user" => user_params}) do
      case UserContext.create_user(user_params) do
        {:ok, user} ->

          newconfirm(user)

          conn
          |> put_flash(:info, gettext("Signed up successfully! Now please login!"))
          |> redirect(to: "/login")
          
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "signup.html", changeset: changeset, action: Routes.session_path(conn, :showSignup), acceptable_roles: ["User"])
      end
  end

  def newconfirm(user) do
    code = Randomizer.randomizer(20)
    link = %{:link => code}
    ConfirmContext.create_confirm(link, user)
    Email.welcome_email(user.email, code)
    |> Mailer.deliver_now!()
  end

  def updateconfirm(confirm, user) do
    code = Randomizer.randomizer(20)
    link = %{:link => code}
    confirm_new = Map.put(confirm, "link", link)
    ConfirmContext.update_confirm(confirm, link)
    Email.welcome_email(user.email, code)
    |> Mailer.deliver_now!()
  end

  def deleteConfirm(conn, %{"confirm" => id}) do
    confirm = ConfirmContext.get_confirm!(id)
    {:ok, _confirm} = ConfirmContext.delete_confirm(confirm)

  end

  def confirm(conn, %{"id" => id}) do
    user = Guardian.Plug.current_resource(conn);
    confirmTest = ConfirmContext.get_confirm_by_link(id)
    user2 = UserContext.get_user!(confirmTest.user_id)
    if (user.id == user2.id || user.role == "Admin") do
    
      confirm = ConfirmContext.get_confirm_by_user_id(user2.id)
      {:ok, time} = DateTime.from_naive(confirm.updated_at, "Etc/UTC")
      {:ok, now} = DateTime.now("Europe/Copenhagen")
      diff = DateTime.diff(now, time)
      if diff < 86400 do
        ConfirmContext.delete_confirm(confirm)
        {:ok, _user} = UserContext.change_confirm(user, %{"confirmed" => true})
        conn
        |> put_flash(:info, "User confirmed succesfully!")
        |> redirect(to: Routes.page_path(conn, :index))
      else
        updateconfirm(confirm, user)
        conn
        |> put_flash(:error, "Your confirmation link expired. Please check your mail for a new confirmation link.")
        |> redirect(to: Routes.page_path(conn, :index))
      end
    else
      conn
      |> put_flash(:error, "You do not have access to confirm this account.")
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end


end