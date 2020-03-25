defmodule InnCheck.Clients.Inn do
  use Ecto.Schema
  import Ecto.Changeset
  import InnCheck.Utils.InnValidator

  alias InnCheck.Clients.Client

  schema "inns" do
    field :is_valid, :boolean, default: false
    field :number, :string

    belongs_to :client, Client

    timestamps()
  end

  @doc false
  def changeset(inn, attrs) do
    inn
    |> cast(attrs, [:number, :is_valid])
    |> validate_required([:number], message: "Пожалуйста, заполните ИНН")
    |> validate_format(:number, ~r/[^-]\d+/, message: "ИНН может состоять только из цифр")
    |> validate_length(:number, min: 10, message: "ИНН может состоять только из 10 или 12 цифр")
    |> validate_inn()
  end
end
