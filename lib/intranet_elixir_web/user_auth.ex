defmodule IntranetElixirWeb.UserAuth do
  @moduledoc """
  Functions for user authentication
  """

  import Plug.Conn
  import Phoenix.Controller

  alias IntranetElixir.Guardian

  def fetch_current_user(conn, _opts) do
    case Guardian.Plug.current_resource(conn) do
      nil -> assign(conn, :current_user, nil)
      user -> assign(conn, :current_user, user)
    end
  end

  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, "Você precisa estar logado para acessar esta página.")
      |> redirect(to: "/login")
      |> halt()
    end
  end

  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: "/admin")
      |> halt()
    else
      conn
    end
  end
end
