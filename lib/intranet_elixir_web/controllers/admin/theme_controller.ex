defmodule IntranetElixirWeb.Admin.ThemeController do
  use IntranetElixirWeb, :controller

  alias IntranetElixir.Settings
  alias IntranetElixir.Settings.Theme

  def index(conn, _params) do
    themes = Settings.list_themes()
    render(conn, :index, themes: themes)
  end

  def show(conn, %{"id" => id}) do
    theme = Settings.get_theme!(id)
    render(conn, :show, theme: theme)
  end

  def new(conn, _params) do
    changeset = Settings.change_theme(%Theme{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"theme" => theme_params}) do
    case Settings.create_theme(theme_params) do
      {:ok, theme} ->
        conn
        |> put_flash(:info, "Tema criado com sucesso.")
        |> redirect(to: ~p"/admin/themes/#{theme}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    theme = Settings.get_theme!(id)
    changeset = Settings.change_theme(theme)
    render(conn, :edit, theme: theme, changeset: changeset)
  end

  def update(conn, %{"id" => id, "theme" => theme_params}) do
    theme = Settings.get_theme!(id)

    case Settings.update_theme(theme, theme_params) do
      {:ok, theme} ->
        conn
        |> put_flash(:info, "Tema atualizado com sucesso.")
        |> redirect(to: ~p"/admin/themes/#{theme}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, theme: theme, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    theme = Settings.get_theme!(id)

    if theme.active do
      conn
      |> put_flash(:error, "Não é possível deletar um tema ativo.")
      |> redirect(to: ~p"/admin/themes")
    else
      {:ok, _theme} = Settings.delete_theme(theme)

      conn
      |> put_flash(:info, "Tema deletado com sucesso.")
      |> redirect(to: ~p"/admin/themes")
    end
  end

  def activate(conn, %{"id" => id}) do
    theme = Settings.get_theme!(id)

    case Settings.activate_theme(theme) do
      {:ok, _theme} ->
        conn
        |> put_flash(:info, "Tema ativado com sucesso.")
        |> redirect(to: ~p"/admin/themes")

      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> put_flash(:error, "Erro ao ativar tema.")
        |> redirect(to: ~p"/admin/themes")
    end
  end
end
