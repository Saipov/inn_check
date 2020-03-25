defmodule InnCheck.Repo.Migrations.CreateClients do
  use Ecto.Migration

  def change do
    create table(:clients) do
      add :ip_address, :string
      add :is_banned, :boolean, default: false, null: false

      timestamps()
    end
  end
end
