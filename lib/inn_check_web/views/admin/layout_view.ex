defmodule InnCheckWeb.Admin.LayoutView do
  use InnCheckWeb, :view

  def active_class(conn, path) do
    if path == Phoenix.Controller.current_path(conn) do
      "active"
    else
      ""
    end
  end
end
