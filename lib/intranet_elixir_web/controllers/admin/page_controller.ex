defmodule IntranetElixirWeb.Admin.PageController do
  use IntranetElixirWeb, :controller

  alias IntranetElixir.Content
  alias IntranetElixir.Content.Page
  alias IntranetElixir.Services.ContentService

  def index(conn, _params) do
    pages = Content.list_pages()
    render(conn, :index, pages: pages)
  end

  def show(conn, %{"id" => id}) do
    page = Content.get_page!(id)
    render(conn, :show, page: page)
  end

  def new(conn, _params) do
    changeset = Content.change_page(%Page{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"page" => page_params}) do
    user = conn.assigns[:current_user]

    case ContentService.create_page(user, page_params) do
      {:ok, page} ->
        conn
        |> put_flash(:info, "Página criada com sucesso.")
        |> redirect(to: ~p"/admin/pages/#{page}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    page = Content.get_page!(id)
    changeset = Content.change_page(page)
    render(conn, :edit, page: page, changeset: changeset)
  end

  def update(conn, %{"id" => id, "page" => page_params}) do
    page = Content.get_page!(id)
    user = conn.assigns[:current_user]

    case ContentService.update_page(user, page, page_params) do
      {:ok, page} ->
        conn
        |> put_flash(:info, "Página atualizada com sucesso.")
        |> redirect(to: ~p"/admin/pages/#{page}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, page: page, changeset: changeset)

      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "Você não tem permissão para editar esta página.")
        |> redirect(to: ~p"/admin/pages")
    end
  end

  def delete(conn, %{"id" => id}) do
    page = Content.get_page!(id)
    user = conn.assigns[:current_user]

    case ContentService.delete_page(user, page) do
      {:ok, _page} ->
        conn
        |> put_flash(:info, "Página deletada com sucesso.")
        |> redirect(to: ~p"/admin/pages")

      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "Você não tem permissão para deletar esta página.")
        |> redirect(to: ~p"/admin/pages")
    end
  end

  def approve(conn, %{"id" => id}) do
    page = Content.get_page!(id)
    user = conn.assigns[:current_user]

    case ContentService.approve_page(user, page) do
      {:ok, _page} ->
        conn
        |> put_flash(:info, "Página aprovada com sucesso.")
        |> redirect(to: ~p"/admin/pages")

      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "Você não tem permissão para aprovar páginas.")
        |> redirect(to: ~p"/admin/pages")
    end
  end
end
