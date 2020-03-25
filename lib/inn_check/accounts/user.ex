defmodule InnCheck.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :roles, {:array, :string}, default: ["admin"]
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :roles, :password])
    |> validate_required([:name, :password])
    |> unique_constraint(:name)
    |> put_hashed_password()
  end

  defp put_hashed_password(changeset) do
    case changeset.valid? do
      true ->
        changes = changeset.changes
        put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(changes.password))

      _ ->
        changeset
    end
  end
end
