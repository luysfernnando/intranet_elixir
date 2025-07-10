defmodule IntranetElixirWeb.Admin.DashboardController do
  use IntranetElixirWeb, :controller

  alias IntranetElixir.Content
  alias IntranetElixir.Accounts

  def index(conn, _params) do
    _user = conn.assigns[:current_user]

    # Statistics
    total_posts = Content.list_posts() |> length()
    total_pages = Content.list_pages() |> length()
    pending_posts = Content.list_pending_posts() |> length()
    pending_pages = Content.list_pending_pages() |> length()
    total_users = Accounts.list_users() |> length()

    # Recent content
    recent_posts = Content.list_posts() |> Enum.take(5)
    recent_pages = Content.list_pages() |> Enum.take(5)

    render(conn, :index,
      total_posts: total_posts,
      total_pages: total_pages,
      pending_posts: pending_posts,
      pending_pages: pending_pages,
      total_users: total_users,
      recent_posts: recent_posts,
      recent_pages: recent_pages
    )
  end
end
