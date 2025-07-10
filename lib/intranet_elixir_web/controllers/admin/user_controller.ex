defmodule IntranetElixirWeb.Admin.UserController do
  use IntranetElixirWeb, :controller

  alias IntranetElixir.Accounts
  alias IntranetElixir.Accounts.User

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Usuário criado com sucesso.")
        |> redirect(to: ~p"/admin/users")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, :edit, user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, _updated_user} ->
        conn
        |> put_flash(:info, "Usuário atualizado com sucesso.")
        |> redirect(to: ~p"/admin/users")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    current_user = conn.assigns[:current_user]

    if user.id == current_user.id do
      conn
      |> put_flash(:error, "Você não pode deletar sua própria conta.")
      |> redirect(to: ~p"/admin/users")
    else
      {:ok, _user} = Accounts.delete_user(user)

      conn
      |> put_flash(:info, "Usuário deletado com sucesso.")
      |> redirect(to: ~p"/admin/users")
    end
  end
end
