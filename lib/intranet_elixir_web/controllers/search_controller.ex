defmodule IntranetElixirWeb.SearchController do
  use IntranetElixirWeb, :controller

  alias IntranetElixir.Content

  def index(conn, %{"q" => query}) when is_binary(query) and query != "" do
    results = Content.search_content(query)

    render(conn, :index, query: query, results: results)
  end

  def index(conn, _params) do
    render(conn, :index, query: "", results: %{posts: [], pages: []})
  end

  def by_category(conn, %{"category" => category}) do
    posts = Content.get_posts_by_category(category)
    pages = Content.get_pages_by_category(category)

    render(conn, :by_category, category: category, posts: posts, pages: pages)
  end

  def by_tag(conn, %{"tag" => tag}) do
    posts = Content.get_posts_by_tag(tag)
    pages = Content.get_pages_by_tag(tag)

    render(conn, :by_tag, tag: tag, posts: posts, pages: pages)
  end

  def suggestions(conn, %{"type" => "categories", "q" => query}) do
    suggestions = Content.get_category_suggestions(query)
    json(conn, %{suggestions: suggestions})
  end

  def suggestions(conn, %{"type" => "tags", "q" => query}) do
    suggestions = Content.get_tag_suggestions(query)
    json(conn, %{suggestions: suggestions})
  end

  def suggestions(conn, _params) do
    json(conn, %{suggestions: []})
  end
end
