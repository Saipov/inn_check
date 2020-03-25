defmodule InnCheckWeb.Admin.SessionController do
  use InnCheckWeb, :controller
  plug :set_layout

  alias InnCheck.{Accounts, Accounts.User, Accounts.Guardian}

  defp set_layout(conn, _) do
    conn
    |> put_layout("admin_login.html")
  end

  def new(conn, _) do
    changeset = Accounts.change_user(%User{})
    user = Guardian.Plug.current_resource(conn)

    if user do
      redirect(conn, to: "/admin")
    else
      render(conn, "login.html",
        changeset: changeset,
        action: Routes.admin_session_path(conn, :login)
      )
    end
  end

  def login(conn, %{"session" => session_params}) do
    Accounts.get_user_by_credentials(session_params)
    |> login_reply(conn)
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/")
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_session(:user_id, user.id)
    |> put_flash(:info, "Welcome back!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/admin")
  end

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_flash(:error, to_string(reason))
    |> new(%{})
  end
end
