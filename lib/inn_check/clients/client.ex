defmodule InnCheck.Clients.Client do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clients" do
    field :ip_address, :string
    field :is_banned, :boolean, default: false
    has_many :inn, InnCheck.Clients.Inn

    timestamps()
  end

  @doc false
  def changeset(client, attrs) do
    client
    |> cast(attrs, [:ip_address, :is_banned])
    |> validate_required([:ip_address, :is_banned])
  end
end
