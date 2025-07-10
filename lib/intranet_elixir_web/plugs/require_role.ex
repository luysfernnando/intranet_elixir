defmodule IntranetElixirWeb.Plugs.RequireRole do
  @moduledoc """
  Plug to require specific user roles
  """

  import Plug.Conn
  import Phoenix.Controller

  def init(roles) when is_list(roles), do: roles

  def call(conn, roles) do
    user = conn.assigns[:current_user]

    if user && user.role in roles do
      conn
    else
      conn
      |> put_flash(:error, "Você não tem permissão para acessar esta página.")
      |> redirect(to: "/")
      |> halt()
    end
  end
end
