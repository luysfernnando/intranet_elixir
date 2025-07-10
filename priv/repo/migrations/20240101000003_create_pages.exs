defmodule IntranetElixir.Repo.Migrations.CreatePages do
  use Ecto.Migration

  def change do
    create table(:pages) do
      add :title, :string, null: false
      add :content, :text, null: false
      add :slug, :string, null: false
      add :status, :string, null: false, default: "draft"
      add :featured_image, :string
      add :excerpt, :text
      add :published_at, :naive_datetime
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:pages, [:user_id])
    create unique_index(:pages, [:slug])
    create index(:pages, [:status])
    create index(:pages, [:published_at])
  end
end
