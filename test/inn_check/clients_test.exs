defmodule InnCheck.ClientsTest do
  use InnCheck.DataCase

  alias InnCheck.Clients

  describe "clients" do
    alias InnCheck.Clients.Client

    @valid_attrs %{ip_address: "some ip_address", is_banned: true}
    @update_attrs %{ip_address: "some updated ip_address", is_banned: false}
    @invalid_attrs %{ip_address: nil, is_banned: nil}

    def client_fixture(attrs \\ %{}) do
      {:ok, client} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Clients.create_client()

      client
    end

    test "list_clients/0 returns all clients" do
      client = client_fixture()
      assert Clients.list_clients() == [client]
    end

    test "get_client!/1 returns the client with given id" do
      client = client_fixture()
      assert Clients.get_client!(client.id) == client
    end

    test "create_client/1 with valid data creates a client" do
      assert {:ok, %Client{} = client} = Clients.create_client(@valid_attrs)
      assert client.ip_address == "some ip_address"
      assert client.is_banned == true
    end

    test "create_client/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Clients.create_client(@invalid_attrs)
    end

    test "update_client/2 with valid data updates the client" do
      client = client_fixture()
      assert {:ok, %Client{} = client} = Clients.update_client(client, @update_attrs)
      assert client.ip_address == "some updated ip_address"
      assert client.is_banned == false
    end

    test "update_client/2 with invalid data returns error changeset" do
      client = client_fixture()
      assert {:error, %Ecto.Changeset{}} = Clients.update_client(client, @invalid_attrs)
      assert client == Clients.get_client!(client.id)
    end

    test "delete_client/1 deletes the client" do
      client = client_fixture()
      assert {:ok, %Client{}} = Clients.delete_client(client)
      assert_raise Ecto.NoResultsError, fn -> Clients.get_client!(client.id) end
    end

    test "change_client/1 returns a client changeset" do
      client = client_fixture()
      assert %Ecto.Changeset{} = Clients.change_client(client)
    end
  end

  describe "inns" do
    alias InnCheck.Clients.Inn

    @valid_attrs %{is_valid: true, number: "some number"}
    @update_attrs %{is_valid: false, number: "some updated number"}
    @invalid_attrs %{is_valid: nil, number: nil}

    def inn_fixture(attrs \\ %{}) do
      {:ok, inn} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Clients.create_inn()

      inn
    end

    test "list_inns/0 returns all inns" do
      inn = inn_fixture()
      assert Clients.list_inns() == [inn]
    end

    test "get_inn!/1 returns the inn with given id" do
      inn = inn_fixture()
      assert Clients.get_inn!(inn.id) == inn
    end

    test "create_inn/1 with valid data creates a inn" do
      assert {:ok, %Inn{} = inn} = Clients.create_inn(@valid_attrs)
      assert inn.is_valid == true
      assert inn.number == "some number"
    end

    test "create_inn/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Clients.create_inn(@invalid_attrs)
    end

    test "update_inn/2 with valid data updates the inn" do
      inn = inn_fixture()
      assert {:ok, %Inn{} = inn} = Clients.update_inn(inn, @update_attrs)
      assert inn.is_valid == false
      assert inn.number == "some updated number"
    end

    test "update_inn/2 with invalid data returns error changeset" do
      inn = inn_fixture()
      assert {:error, %Ecto.Changeset{}} = Clients.update_inn(inn, @invalid_attrs)
      assert inn == Clients.get_inn!(inn.id)
    end

    test "delete_inn/1 deletes the inn" do
      inn = inn_fixture()
      assert {:ok, %Inn{}} = Clients.delete_inn(inn)
      assert_raise Ecto.NoResultsError, fn -> Clients.get_inn!(inn.id) end
    end

    test "change_inn/1 returns a inn changeset" do
      inn = inn_fixture()
      assert %Ecto.Changeset{} = Clients.change_inn(inn)
    end
  end
end
