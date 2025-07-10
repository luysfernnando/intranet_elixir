defmodule IntranetElixir.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias IntranetElixir.Repo

  alias IntranetElixir.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single user.

  ## Examples

      iex> get_user(123)
      %User{}

      iex> get_user(456)
      nil

  """
  def get_user(id), do: Repo.get(User, id)

  @doc """
  Gets a user by email.

  ## Examples

      iex> get_user_by_email("test@example.com")
      %User{}

      iex> get_user_by_email("invalid@example.com")
      nil

  """
  def get_user_by_email(email), do: Repo.get_by(User, email: email)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a user password.

  ## Examples

      iex> update_user_password(user, %{password: new_password})
      {:ok, %User{}}

      iex> update_user_password(user, %{password: bad_password})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_password(%User{} = user, attrs) do
    user
    |> User.password_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  @doc """
  Authenticates a user by email and password.

  ## Examples

      iex> authenticate_user("test@example.com", "password")
      {:ok, %User{}}

      iex> authenticate_user("test@example.com", "invalid")
      {:error, :invalid_credentials}

  """
  def authenticate_user(email, password) do
    case get_user_by_email(email) do
      nil ->
        {:error, :invalid_credentials}

      user ->
        if user.active and User.verify_password(user, password) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end

  @doc """
  Checks if a user has permission to perform an action.

  ## Examples

      iex> can_user?(user, :create_post)
      true

      iex> can_user?(user, :delete_user)
      false

  """
  def can_user?(user, action) do
    case {user.role, action} do
      # Admin can do everything
      {:admin, _} -> true

      # Supervisor permissions
      {:supervisor, :approve_post} -> true
      {:supervisor, :delete_post} -> true
      {:supervisor, :delete_page} -> true
      {:supervisor, :create_post} -> true
      {:supervisor, :update_post} -> true
      {:supervisor, :create_page} -> true
      {:supervisor, :update_page} -> true
      {:supervisor, :view_admin} -> true

      # Editor permissions
      {:editor, :create_post} -> true
      {:editor, :update_post} -> true
      {:editor, :create_page} -> true
      {:editor, :update_page} -> true
      {:editor, :view_admin} -> true

      # Estagiario permissions
      {:estagiario, :create_post} -> true
      {:estagiario, :update_post} -> true
      {:estagiario, :create_page} -> true
      {:estagiario, :update_page} -> true
      {:estagiario, :view_admin} -> true

      # Default deny
      _ -> false
    end
  end
end
