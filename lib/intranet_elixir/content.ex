defmodule IntranetElixir.Content do
  @moduledoc """
  The Content context.
  """

  import Ecto.Query, warn: false
  alias IntranetElixir.Repo

  alias IntranetElixir.Content.Post
  alias IntranetElixir.Content.Page

  # Posts

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
    |> Repo.preload(:user)
  end

  @doc """
  Returns the list of published posts.

  ## Examples

      iex> list_published_posts()
      [%Post{}, ...]

  """
  def list_published_posts do
    from(p in Post, where: p.status == :published, order_by: [desc: p.published_at])
    |> Repo.all()
    |> Repo.preload(:user)
  end

  @doc """
  Returns the list of posts pending approval.

  ## Examples

      iex> list_pending_posts()
      [%Post{}, ...]

  """
  def list_pending_posts do
    from(p in Post, where: p.status == :pending_approval, order_by: [desc: p.inserted_at])
    |> Repo.all()
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id) do
    Repo.get!(Post, id)
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single post by slug.

  ## Examples

      iex> get_post_by_slug("my-post")
      %Post{}

      iex> get_post_by_slug("invalid-slug")
      nil

  """
  def get_post_by_slug(slug) do
    from(p in Post, where: p.slug == ^slug and p.status == :published)
    |> Repo.one()
    |> Repo.preload(:user)
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  @doc """
  Approves a post for publication.

  ## Examples

      iex> approve_post(post)
      {:ok, %Post{}}

      iex> approve_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def approve_post(%Post{} = post) do
    update_post(post, %{status: :published, published_at: NaiveDateTime.utc_now()})
  end

  # Pages

  @doc """
  Returns the list of pages.

  ## Examples

      iex> list_pages()
      [%Page{}, ...]

  """
  def list_pages do
    Repo.all(Page)
    |> Repo.preload(:user)
  end

  @doc """
  Returns the list of published pages.

  ## Examples

      iex> list_published_pages()
      [%Page{}, ...]

  """
  def list_published_pages do
    from(p in Page, where: p.status == :published, order_by: [desc: p.published_at])
    |> Repo.all()
    |> Repo.preload(:user)
  end

  @doc """
  Returns the list of pages pending approval.

  ## Examples

      iex> list_pending_pages()
      [%Page{}, ...]

  """
  def list_pending_pages do
    from(p in Page, where: p.status == :pending_approval, order_by: [desc: p.inserted_at])
    |> Repo.all()
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single page.

  Raises `Ecto.NoResultsError` if the Page does not exist.

  ## Examples

      iex> get_page!(123)
      %Page{}

      iex> get_page!(456)
      ** (Ecto.NoResultsError)

  """
  def get_page!(id) do
    Repo.get!(Page, id)
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single page by slug.

  ## Examples

      iex> get_page_by_slug("my-page")
      %Page{}

      iex> get_page_by_slug("invalid-slug")
      nil

  """
  def get_page_by_slug(slug) do
    from(p in Page, where: p.slug == ^slug and p.status == :published)
    |> Repo.one()
    |> Repo.preload(:user)
  end

  @doc """
  Creates a page.

  ## Examples

      iex> create_page(%{field: value})
      {:ok, %Page{}}

      iex> create_page(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_page(attrs \\ %{}) do
    %Page{}
    |> Page.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a page.

  ## Examples

      iex> update_page(page, %{field: new_value})
      {:ok, %Page{}}

      iex> update_page(page, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_page(%Page{} = page, attrs) do
    page
    |> Page.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a page.

  ## Examples

      iex> delete_page(page)
      {:ok, %Page{}}

      iex> delete_page(page)
      {:error, %Ecto.Changeset{}}

  """
  def delete_page(%Page{} = page) do
    Repo.delete(page)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking page changes.

  ## Examples

      iex> change_page(page)
      %Ecto.Changeset{data: %Page{}}

  """
  def change_page(%Page{} = page, attrs \\ %{}) do
    Page.changeset(page, attrs)
  end

  @doc """
  Approves a page for publication.

  ## Examples

      iex> approve_page(page)
      {:ok, %Page{}}

      iex> approve_page(page)
      {:error, %Ecto.Changeset{}}

  """
  def approve_page(%Page{} = page) do
    update_page(page, %{status: :published, published_at: NaiveDateTime.utc_now()})
  end
end
