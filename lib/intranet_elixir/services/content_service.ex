defmodule IntranetElixir.Services.ContentService do
  @moduledoc """
  Service for content operations with permission checking.
  """

  alias IntranetElixir.Content
  alias IntranetElixir.Accounts

  @doc """
  Creates a post with automatic status based on user role.
  """
  def create_post(user, attrs) do
    # Determine status based on user role
    status =
      case user.role do
        :estagiario -> :pending_approval
        _ -> :published
      end

    published_at =
      if status == :published do
        NaiveDateTime.utc_now()
      else
        nil
      end

    attrs =
      attrs
      |> Map.put("status", status)
      |> Map.put("published_at", published_at)
      |> Map.put("user_id", user.id)

    Content.create_post(attrs)
  end

  @doc """
  Updates a post with permission checking.
  """
  def update_post(user, post, attrs) do
    cond do
      # Admin can update any post
      user.role == :admin ->
        Content.update_post(post, attrs)

      # Supervisor can update any post
      user.role == :supervisor ->
        Content.update_post(post, attrs)

      # Editor can update their own posts
      user.role == :editor and post.user_id == user.id ->
        Content.update_post(post, attrs)

      # Estagiario can update their own posts but needs approval
      user.role == :estagiario and post.user_id == user.id ->
        attrs = Map.put(attrs, "status", :pending_approval)
        Content.update_post(post, attrs)

      true ->
        {:error, :unauthorized}
    end
  end

  @doc """
  Deletes a post with permission checking.
  """
  def delete_post(user, post) do
    cond do
      # Admin can delete any post
      user.role == :admin ->
        Content.delete_post(post)

      # Supervisor can delete any post
      user.role == :supervisor ->
        Content.delete_post(post)

      # Users can delete their own posts
      post.user_id == user.id ->
        Content.delete_post(post)

      true ->
        {:error, :unauthorized}
    end
  end

  @doc """
  Creates a page with automatic status based on user role.
  """
  def create_page(user, attrs) do
    # Determine status based on user role
    status =
      case user.role do
        :estagiario -> :pending_approval
        _ -> :published
      end

    published_at =
      if status == :published do
        NaiveDateTime.utc_now()
      else
        nil
      end

    attrs =
      attrs
      |> Map.put("status", status)
      |> Map.put("published_at", published_at)
      |> Map.put("user_id", user.id)

    Content.create_page(attrs)
  end

  @doc """
  Updates a page with permission checking.
  """
  def update_page(user, page, attrs) do
    cond do
      # Admin can update any page
      user.role == :admin ->
        Content.update_page(page, attrs)

      # Supervisor can update any page
      user.role == :supervisor ->
        Content.update_page(page, attrs)

      # Editor can update their own pages
      user.role == :editor and page.user_id == user.id ->
        Content.update_page(page, attrs)

      # Estagiario can update their own pages but needs approval
      user.role == :estagiario and page.user_id == user.id ->
        attrs = Map.put(attrs, "status", :pending_approval)
        Content.update_page(page, attrs)

      true ->
        {:error, :unauthorized}
    end
  end

  @doc """
  Deletes a page with permission checking.
  """
  def delete_page(user, page) do
    cond do
      # Admin can delete any page
      user.role == :admin ->
        Content.delete_page(page)

      # Supervisor can delete any page
      user.role == :supervisor ->
        Content.delete_page(page)

      # Users can delete their own pages
      page.user_id == user.id ->
        Content.delete_page(page)

      true ->
        {:error, :unauthorized}
    end
  end

  @doc """
  Approves a post (only admin and supervisor can do this).
  """
  def approve_post(user, post) do
    if Accounts.can_user?(user, :approve_post) do
      Content.approve_post(post)
    else
      {:error, :unauthorized}
    end
  end

  @doc """
  Approves a page (only admin and supervisor can do this).
  """
  def approve_page(user, page) do
    if Accounts.can_user?(user, :approve_post) do
      Content.approve_page(page)
    else
      {:error, :unauthorized}
    end
  end
end
