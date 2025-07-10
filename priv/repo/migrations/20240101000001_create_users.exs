defmodule IntranetElixir.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :password_hash, :string, null: false
      add :role, :string, null: false
      add :active, :boolean, default: true, null: false

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
