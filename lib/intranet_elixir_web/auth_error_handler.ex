defmodule IntranetElixirWeb.AuthErrorHandler do
  @moduledoc """
  Guardian error handler for authentication failures
  """

  import Phoenix.Controller

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    body = to_string(type)

    conn
    |> put_flash(:error, "Erro de autenticação: #{body}")
    |> redirect(to: "/login")
  end
end
