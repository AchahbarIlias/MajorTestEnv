defmodule Jmunited.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset

  @acceptable_roles ["Admin","User"]

  schema "users" do
    field :city, :string
    field :country, :string
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :number, :integer
    field :street, :string
    field :zip, :integer
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :role, :string, default: "User"
    field :confirmed, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :country, :city, :zip, :street, :number, :password, :confirmed, :role])
    |> validate_required([:first_name, :last_name, :email, :country, :city, :zip, :street, :number])
    |> validate_inclusion(:role, @acceptable_roles)
    |> put_password_hash()
    |> unique_constraint(:email)
  end

  def changeset_admin(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :country, :city, :zip, :street, :number, :password, :role])
    |> validate_required([:first_name, :last_name, :email, :country, :city, :zip, :street, :number, :role])
    |> validate_inclusion(:role, @acceptable_roles)
    |> put_password_hash()
    |> unique_constraint(:email)
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, hashed_password: Pbkdf2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset

  def get_acceptable_roles, do: @acceptable_roles

  def changeset_confirm(user, params \\ %{}) do
    user
    |> cast(params, [:confirmed], [])
  end
end