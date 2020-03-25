defmodule InnCheckWeb.Admin.DashboardController do
  use InnCheckWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
