defmodule IntranetElixirWeb.PageController do
  use IntranetElixirWeb, :controller

  alias IntranetElixir.Content
  alias IntranetElixir.Settings

  def index(conn, _params) do
    posts = Content.list_published_posts() |> Enum.take(5)
    pages = Content.list_published_pages() |> Enum.take(6)
    theme = Settings.get_active_theme()

    render(conn, :index, posts: posts, pages: pages, theme: theme)
  end

  def list(conn, _params) do
    pages = Content.list_published_pages()
    render(conn, :list, pages: pages)
  end

  def show(conn, %{"slug" => slug}) do
    case Content.get_page_by_slug(slug) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(IntranetElixirWeb.ErrorHTML)
        |> render(:"404")

      page ->
        render(conn, :show, page: page)
    end
  end
end
