defmodule IntranetElixirWeb.SessionController do
  use IntranetElixirWeb, :controller

  alias IntranetElixir.Services.AuthService

  def new(conn, _params) do
    if conn.assigns[:current_user] do
      redirect(conn, to: "/admin")
    else
      render(conn, :new)
    end
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case AuthService.authenticate(email, password) do
      {:ok, user, _token} ->
        conn
        |> IntranetElixir.Guardian.Plug.sign_in(user)
        |> put_flash(:info, "Bem-vindo, #{user.name}!")
        |> redirect(to: "/admin")

      {:error, :invalid_credentials} ->
        conn
        |> put_flash(:error, "Email ou senha inválidos.")
        |> render(:new)
    end
  end

  def delete(conn, _params) do
    conn
    |> IntranetElixir.Guardian.Plug.sign_out()
    |> put_flash(:info, "Você foi desconectado.")
    |> redirect(to: "/")
  end
end
