defmodule InnCheckWeb.InnController do
  use InnCheckWeb, :controller

  alias InnCheck.Clients

  def create(conn, %{"client_id" => client_id, "inn" => inn_params}) do
    client =
      if client_id == "false" do
        Clients.create_client_by_ip(%{"ip_address" => conn.assigns.ip})
      else
        Clients.get_client!(client_id)
      end

    case Clients.create_inn(client, inn_params) do
      {:ok, _inn} ->
        conn
        |> put_flash(:info, "Inn created successfully.")
        |> redirect(to: Routes.client_path(conn, :index))

      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> put_flash(:error, "Inn not created.")
        |> redirect(to: Routes.client_path(conn, :index))
    end
  end
end
