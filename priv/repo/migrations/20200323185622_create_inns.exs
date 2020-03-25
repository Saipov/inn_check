defmodule InnCheck.Repo.Migrations.CreateInns do
  use Ecto.Migration

  def change do
    create table(:inns) do
      add :number, :string
      add :is_valid, :boolean, default: false, null: false
      add :client_id, references(:clients, on_delete: :delete_all)

      timestamps()
    end

    create index(:inns, [:client_id])
  end
end
