defmodule IntranetElixir.Settings do
  @moduledoc """
  The Settings context.
  """

  import Ecto.Query, warn: false
  alias IntranetElixir.Repo

  alias IntranetElixir.Settings.Theme

  @doc """
  Returns the list of themes.

  ## Examples

      iex> list_themes()
      [%Theme{}, ...]

  """
  def list_themes do
    Repo.all(Theme)
  end

  @doc """
  Gets the active theme.

  ## Examples

      iex> get_active_theme()
      %Theme{}

      iex> get_active_theme()
      nil

  """
  def get_active_theme do
    Repo.one(from t in Theme, where: t.active == true)
  end

  @doc """
  Gets a single theme.

  Raises `Ecto.NoResultsError` if the Theme does not exist.

  ## Examples

      iex> get_theme!(123)
      %Theme{}

      iex> get_theme!(456)
      ** (Ecto.NoResultsError)

  """
  def get_theme!(id), do: Repo.get!(Theme, id)

  @doc """
  Creates a theme.

  ## Examples

      iex> create_theme(%{field: value})
      {:ok, %Theme{}}

      iex> create_theme(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_theme(attrs \\ %{}) do
    %Theme{}
    |> Theme.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a theme.

  ## Examples

      iex> update_theme(theme, %{field: new_value})
      {:ok, %Theme{}}

      iex> update_theme(theme, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_theme(%Theme{} = theme, attrs) do
    theme
    |> Theme.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Activates a theme (deactivates all others).

  ## Examples

      iex> activate_theme(theme)
      {:ok, %Theme{}}

      iex> activate_theme(theme)
      {:error, %Ecto.Changeset{}}

  """
  def activate_theme(%Theme{} = theme) do
    Repo.transaction(fn ->
      # Deactivate all themes
      from(t in Theme, update: [set: [active: false]])
      |> Repo.update_all([])

      # Activate the selected theme
      theme
      |> Theme.changeset(%{active: true})
      |> Repo.update()
      |> case do
        {:ok, theme} -> theme
        {:error, changeset} -> Repo.rollback(changeset)
      end
    end)
  end

  @doc """
  Deletes a theme.

  ## Examples

      iex> delete_theme(theme)
      {:ok, %Theme{}}

      iex> delete_theme(theme)
      {:error, %Ecto.Changeset{}}

  """
  def delete_theme(%Theme{} = theme) do
    Repo.delete(theme)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking theme changes.

  ## Examples

      iex> change_theme(theme)
      %Ecto.Changeset{data: %Theme{}}

  """
  def change_theme(%Theme{} = theme, attrs \\ %{}) do
    Theme.changeset(theme, attrs)
  end
end
