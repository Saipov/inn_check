defmodule InnCheck.Clients do
  @moduledoc """
  The Clients context.
  """

  import Ecto.Query, warn: false
  alias InnCheck.Repo

  alias InnCheck.Clients.Client
  alias InnCheck.Clients.Inn

  defdelegate authorize(action, user, params), to: InnCheck.Clients.Policy

  @doc """
  Returns the list of clients.

  ## Examples

      iex> list_clients()
      [%Client{}, ...]

  """
  def list_clients do
    Client
    |> Repo.all()
    |> Repo.preload(inn: from(p in Inn, order_by: [desc: p.inserted_at]))
  end

  def create_client_by_ip(attrs \\ %{}) do
    case create_client(attrs) do
      {:ok, client} -> client
    end
  end

  def get_client_by_ip(ip) do
    client =
      Client
      |> Repo.get_by(ip_address: ip)
      |> Repo.preload(inn: from(p in Inn, order_by: [desc: p.inserted_at]))

    do_get_client_by_ip(client)
  end

  defp do_get_client_by_ip(nil), do: false
  defp do_get_client_by_ip(client), do: client

  @doc """
  Gets a single client.

  Raises `Ecto.NoResultsError` if the Client does not exist.

  ## Examples

      iex> get_client!(123)
      %Client{}

      iex> get_client!(456)
      ** (Ecto.NoResultsError)

  """
  def get_client!(id) do
    Client
    |> Repo.get!(id)
    |> Repo.preload(:inn)
  end

  @doc """
  Creates a client.

  ## Examples

      iex> create_client(%{field: value})
      {:ok, %Client{}}

      iex> create_client(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_client(attrs \\ %{}) do
    %Client{}
    |> Client.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a client.

  ## Examples

      iex> update_client(client, %{field: new_value})
      {:ok, %Client{}}

      iex> update_client(client, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_client(%Client{} = client, attrs) do
    client
    |> Client.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a client.

  ## Examples

      iex> delete_client(client)
      {:ok, %Client{}}

      iex> delete_client(client)
      {:error, %Ecto.Changeset{}}

  """
  def delete_client(%Client{} = client) do
    Repo.delete(client)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking client changes.

  ## Examples

      iex> change_client(client)
      %Ecto.Changeset{source: %Client{}}

  """
  def change_client(%Client{} = client) do
    Client.changeset(client, %{})
  end

  alias InnCheck.Clients.Inn

  @doc """
  Returns the list of inns.

  ## Examples

      iex> list_inns()
      [%Inn{}, ...]

  """
  def list_inns do
    Repo.all(Inn)
  end

  @doc """
  Gets a single inn.

  Raises `Ecto.NoResultsError` if the Inn does not exist.

  ## Examples

      iex> get_inn!(123)
      %Inn{}

      iex> get_inn!(456)
      ** (Ecto.NoResultsError)

  """
  def get_inn!(id), do: Repo.get!(Inn, id)

  @doc """
  Creates a inn.

  ## Examples

      iex> create_inn(%{field: value})
      {:ok, %Inn{}}

      iex> create_inn(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_inn(%Client{} = client, attrs \\ %{}) do
    client
    |> Ecto.build_assoc(:inn)
    |> Inn.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a inn.

  ## Examples

      iex> update_inn(inn, %{field: new_value})
      {:ok, %Inn{}}

      iex> update_inn(inn, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_inn(%Inn{} = inn, attrs) do
    inn
    |> Inn.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a inn.

  ## Examples

      iex> delete_inn(inn)
      {:ok, %Inn{}}

      iex> delete_inn(inn)
      {:error, %Ecto.Changeset{}}

  """
  def delete_inn(%Inn{} = inn) do
    Repo.delete(inn)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking inn changes.

  ## Examples

      iex> change_inn(inn)
      %Ecto.Changeset{source: %Inn{}}

  """
  def change_inn(%Inn{} = inn) do
    Inn.changeset(inn, %{})
  end
end
