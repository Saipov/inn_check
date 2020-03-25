defmodule InnCheckWeb.Admin.InnController do
  use InnCheckWeb, :controller

  alias InnCheck.Clients
  alias InnCheck.Clients.Inn

  def index(conn, _params) do
    inns = Clients.list_inns()

    changeset = Clients.change_inn(%Inn{})

    render(conn, "index.html", inns: inns, changeset: changeset)
  end

  def new(conn, _params) do
    changeset = Clients.change_inn(%Inn{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"inn" => inn_params}) do
    case Clients.create_inn(inn_params) do
      {:ok, inn} ->
        conn
        |> put_flash(:info, "Inn created successfully.")
        |> redirect(to: Routes.admin_inn_path(conn, :show, inn))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    inn = Clients.get_inn!(id)
    render(conn, "show.html", inn: inn)
  end

  def edit(conn, %{"id" => id}) do
    inn = Clients.get_inn!(id)
    changeset = Clients.change_inn(inn)
    render(conn, "edit.html", inn: inn, changeset: changeset)
  end

  def update(conn, %{"id" => id, "inn" => inn_params}) do
    inn = Clients.get_inn!(id)

    case Clients.update_inn(inn, inn_params) do
      {:ok, inn} ->
        conn
        |> put_flash(:info, "Inn updated successfully.")
        |> redirect(to: Routes.admin_inn_path(conn, :show, inn))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", inn: inn, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    inn = Clients.get_inn!(id)
    {:ok, _inn} = Clients.delete_inn(inn)

    conn
    |> put_flash(:info, "Inn deleted successfully.")
    |> redirect(to: Routes.admin_inn_path(conn, :index))
  end
end
