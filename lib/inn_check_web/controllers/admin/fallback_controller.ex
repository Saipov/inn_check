defmodule InnCheckWeb.Admin.FallbackController do
  use InnCheckWeb, :controller

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:forbidden)
    |> put_view(InnCheckWeb.ErrorView)
    |> render(:"403")
  end
end
