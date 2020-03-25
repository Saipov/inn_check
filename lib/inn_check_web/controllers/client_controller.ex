defmodule InnCheckWeb.ClientController do
  use InnCheckWeb, :controller

  alias InnCheck.Clients
  alias InnCheck.Clients.Inn

  def index(conn, _params) do
    client = Clients.get_client_by_ip(conn.assigns.ip)
    inn_changeset = Clients.change_inn(%Inn{})
    token = Phoenix.Token.sign(conn, "euler.solutions", conn.assigns.ip)
    render(conn, "index.html", client: client, inn_changeset: inn_changeset, token: token)
  end
end
