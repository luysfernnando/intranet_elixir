defmodule IntranetElixirWeb.Admin.PostController do
  use IntranetElixirWeb, :controller

  alias IntranetElixir.Content
  alias IntranetElixir.Content.Post
  alias IntranetElixir.Accounts
  alias IntranetElixir.Services.ContentService

  def index(conn, _params) do
    posts = Content.list_posts()
    render(conn, :index, posts: posts)
  end

  def show(conn, %{"id" => id}) do
    post = Content.get_post!(id)
    render(conn, :show, post: post)
  end

  def new(conn, _params) do
    changeset = Content.change_post(%Post{})
    post = %Post{}
    authors = Accounts.list_users()
    render(conn, :new, changeset: changeset, post: post, authors: authors)
  end

  def create(conn, %{"post" => post_params}) do
    user = conn.assigns[:current_user]

    case ContentService.create_post(user, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post criado com sucesso.")
        |> redirect(to: ~p"/admin/posts/#{post}")

      {:error, %Ecto.Changeset{} = changeset} ->
        post = %Post{}
        authors = Accounts.list_users()
        render(conn, :new, changeset: changeset, post: post, authors: authors)
    end
  end

  def edit(conn, %{"id" => id}) do
    post = Content.get_post!(id)
    changeset = Content.change_post(post)
    authors = Accounts.list_users()
    render(conn, :edit, post: post, changeset: changeset, authors: authors)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Content.get_post!(id)
    user = conn.assigns[:current_user]

    case ContentService.update_post(user, post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post atualizado com sucesso.")
        |> redirect(to: ~p"/admin/posts/#{post}")

      {:error, %Ecto.Changeset{} = changeset} ->
        authors = Accounts.list_users()
        render(conn, :edit, post: post, changeset: changeset, authors: authors)

      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "Você não tem permissão para editar este post.")
        |> redirect(to: ~p"/admin/posts")
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Content.get_post!(id)
    user = conn.assigns[:current_user]

    case ContentService.delete_post(user, post) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post deletado com sucesso.")
        |> redirect(to: ~p"/admin/posts")

      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "Você não tem permissão para deletar este post.")
        |> redirect(to: ~p"/admin/posts")
    end
  end

  def approve(conn, %{"id" => id}) do
    post = Content.get_post!(id)
    user = conn.assigns[:current_user]

    case ContentService.approve_post(user, post) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post aprovado com sucesso.")
        |> redirect(to: ~p"/admin/posts")

      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "Você não tem permissão para aprovar posts.")
        |> redirect(to: ~p"/admin/posts")
    end
  end
end
