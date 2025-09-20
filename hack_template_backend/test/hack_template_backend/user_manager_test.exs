defmodule HackTemplateBackend.UserManagerTest do
  use HackTemplateBackend.DataCase

  alias HackTemplateBackend.UserManager

  describe "users" do
    alias HackTemplateBackend.UserManager.User

    import HackTemplateBackend.UserManagerFixtures

    @invalid_attrs %{username: nil, password: nil}

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = UserManager.create_user(@valid_attrs)
      assert {:ok, user} == Bcrypt.check_pass(user, "some password", hash_key: :password)
      assert user.username == "some username"
    end

    ...

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = UserManager.update_user(user, @update_attrs)
      assert {:ok, user} == Bcrypt.check_pass(user, "some updated password", hash_key: :password)
      assert user.username == "some updated username"
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert UserManager.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert UserManager.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{username: "some username", password: "some password"}

      assert {:ok, %User{} = user} = UserManager.create_user(valid_attrs)
      assert user.username == "some username"
      assert user.password == "some password"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserManager.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{username: "some updated username", password: "some updated password"}

      assert {:ok, %User{} = user} = UserManager.update_user(user, update_attrs)
      assert user.username == "some updated username"
      assert user.password == "some updated password"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = UserManager.update_user(user, @invalid_attrs)
      assert user == UserManager.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = UserManager.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> UserManager.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = UserManager.change_user(user)
    end
  end
end
