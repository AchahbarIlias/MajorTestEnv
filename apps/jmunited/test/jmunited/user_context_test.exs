defmodule Jmunited.UserContextTest do
  use Jmunited.DataCase

  alias Jmunited.UserContext

  describe "users" do
    alias Jmunited.UserContext.User

    @valid_attrs %{city: "some city", country: "some country", email: "some email", first_name: "some first_name", last_name: "some last_name", number: 42, street: "some street", zip: 42}
    @update_attrs %{city: "some updated city", country: "some updated country", email: "some updated email", first_name: "some updated first_name", last_name: "some updated last_name", number: 43, street: "some updated street", zip: 43}
    @invalid_attrs %{city: nil, country: nil, email: nil, first_name: nil, last_name: nil, number: nil, street: nil, zip: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UserContext.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert UserContext.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert UserContext.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = UserContext.create_user(@valid_attrs)
      assert user.city == "some city"
      assert user.country == "some country"
      assert user.email == "some email"
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
      assert user.number == 42
      assert user.street == "some street"
      assert user.zip == 42
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserContext.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = UserContext.update_user(user, @update_attrs)
      assert user.city == "some updated city"
      assert user.country == "some updated country"
      assert user.email == "some updated email"
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
      assert user.number == 43
      assert user.street == "some updated street"
      assert user.zip == 43
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = UserContext.update_user(user, @invalid_attrs)
      assert user == UserContext.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = UserContext.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> UserContext.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = UserContext.change_user(user)
    end
  end
end
