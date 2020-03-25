defmodule InnCheckWeb.InnCheckChannel do
  @moduledoc """
    TODO: Дату и время нужно делать через передачу и вычисления смещения (JS) getTimezoneOffset() - хотя бы;
  """

  use InnCheckWeb, :channel

  alias InnCheck.Clients

  def join("inn_check", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("inn_add", payload, socket) do
    client_id = Clients.get_client_by_ip(socket.assigns.client_ip)
    # Нужно переписать
    client =
      if !client_id do
        Clients.create_client_by_ip(%{"ip_address" => socket.assigns.client_ip})
      else
        Clients.get_client!(client_id.id)
      end

    case Clients.create_inn(client, payload) do
      {:ok, inn} ->
        {:reply, {:ok, %{message: inn_to_map(inn)}}, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:reply, {:error, %{message: changeset_error_to_string(changeset)}}, socket}
    end
  end

  defp inn_to_map(inn) do
    %{
      "inserted_at" => inn.inserted_at,
      "number" => inn.number,
      "is_valid" => inn.is_valid
    }
  end

  def changeset_error_to_string(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.reduce("", fn {_k, v}, _acc ->
      joined_errors = Enum.join(v, "<br>")
      "#{joined_errors}"
    end)
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
