defmodule IntranetElixir.Repo.Seeds do
  @moduledoc """
  Script for populating the database with initial data.
  """

  alias IntranetElixir.Repo
  alias IntranetElixir.Accounts.User
  alias IntranetElixir.Settings.Theme

  def run do
    create_admin_user()
    create_default_theme()
  end

  defp create_admin_user do
    case Repo.get_by(User, email: "admin@intranet.com") do
      nil ->
        %User{}
        |> User.changeset(%{
          name: "Administrador",
          email: "admin@intranet.com",
          password: "123456",
          role: :admin,
          active: true
        })
        |> Repo.insert!()

      _user ->
        :ok
    end
  end

  defp create_default_theme do
    case Repo.get_by(Theme, name: "Default") do
      nil ->
        %Theme{}
        |> Theme.changeset(%{
          name: "Default",
          primary_color: "#3B82F6",
          secondary_color: "#64748B",
          accent_color: "#10B981",
          active: true
        })
        |> Repo.insert!()

      _theme ->
        :ok
    end
  end
end

IntranetElixir.Repo.Seeds.run()
