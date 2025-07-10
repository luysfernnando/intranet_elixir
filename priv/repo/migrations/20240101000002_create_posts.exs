defmodule IntranetElixir.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
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

    create index(:posts, [:user_id])
    create unique_index(:posts, [:slug])
    create index(:posts, [:status])
    create index(:posts, [:published_at])
  end
end
