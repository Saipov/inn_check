defmodule InnCheckWeb.Plug.LoadUser do
  import Plug.Conn

  alias InnCheck.Accounts

  def init(_opts), do: nil

  def call(%Plug.Conn{} = conn, _opts) do
    user_id = get_session(conn, :user_id)
    user = user_id && Accounts.get_user!(user_id)
    assign(conn, :current_user, user)
  end
end
