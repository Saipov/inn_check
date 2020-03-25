defmodule InnCheck.Repo.Migrations.UserAddField do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :roles, {:array, :string}, default: ["admin"]
      add :password_hash, :string
    end
  end
end
