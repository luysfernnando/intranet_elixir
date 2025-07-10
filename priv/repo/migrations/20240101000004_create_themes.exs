defmodule IntranetElixir.Repo.Migrations.CreateThemes do
  use Ecto.Migration

  def change do
    create table(:themes) do
      add :name, :string, null: false
      add :primary_color, :string, null: false
      add :secondary_color, :string, null: false
      add :accent_color, :string, null: false
      add :logo_url, :string
      add :favicon_url, :string
      add :active, :boolean, default: false, null: false

      timestamps()
    end

    create index(:themes, [:active])
  end
end
