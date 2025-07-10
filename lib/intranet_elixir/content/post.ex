defmodule IntranetElixir.Content.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @status_values ~w(draft published pending_approval)a

  schema "posts" do
    field :title, :string
    field :content, :string
    field :slug, :string
    field :status, Ecto.Enum, values: @status_values, default: :draft
    field :featured_image, :string
    field :excerpt, :string
    field :published_at, :naive_datetime

    belongs_to :user, IntranetElixir.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :slug, :status, :featured_image, :excerpt, :published_at, :user_id])
    |> validate_required([:title, :content, :status])
    |> validate_inclusion(:status, @status_values)
    |> generate_slug()
    |> unique_constraint(:slug)
  end

  defp generate_slug(changeset) do
    case get_change(changeset, :title) do
      nil ->
        changeset

      title ->
        slug =
          title
          |> String.downcase()
          |> String.replace(~r/[^a-z0-9\s-]/, "")
          |> String.replace(~r/\s+/, "-")
          |> String.trim("-")

        put_change(changeset, :slug, slug)
    end
  end

  def status_values, do: @status_values
end
