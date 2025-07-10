defmodule IntranetElixirWeb.PostController do
  use IntranetElixirWeb, :controller

  alias IntranetElixir.Content

  def index(conn, _params) do
    posts = Content.list_published_posts()
    render(conn, :index, posts: posts)
  end

  def show(conn, %{"slug" => slug}) do
    case Content.get_post_by_slug(slug) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(IntranetElixirWeb.ErrorHTML)
        |> render(:"404")

      post ->
        render(conn, :show, post: post)
    end
  end
end
