defmodule IntranetElixir.Content.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @status_values ~w(draft published pending_approval)a

  schema "posts" do
    field :title, :string
    field :content, :string
    field :slug, :string
    field :categories, {:array, :string}, default: []
    field :tags, {:array, :string}, default: []
    field :status, Ecto.Enum, values: @status_values, default: :draft
    field :featured_image, :string
    field :excerpt, :string
    field :published_at, :naive_datetime

    # Campos virtuais para os formulários
    field :categories_string, :string, virtual: true
    field :tags_string, :string, virtual: true

    belongs_to :user, IntranetElixir.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :slug, :categories_string, :tags_string, :status, :featured_image, :excerpt, :published_at, :user_id])
    |> validate_required([:title, :content, :status])
    |> validate_inclusion(:status, @status_values)
    |> process_categories_and_tags()
    |> generate_slug()
    |> unique_constraint(:slug)
  end

  defp process_categories_and_tags(changeset) do
    changeset
    |> process_string_to_array(:categories_string, :categories)
    |> process_string_to_array(:tags_string, :tags)
  end

  defp process_string_to_array(changeset, string_field, array_field) do
    case get_change(changeset, string_field) do
      nil ->
        changeset

      value when is_binary(value) ->
        array_value =
          value
          |> String.split(",")
          |> Enum.map(&String.trim/1)
          |> Enum.reject(&(&1 == ""))
          |> Enum.map(&String.downcase/1)
          |> Enum.uniq()

        put_change(changeset, array_field, array_value)

      _ ->
        changeset
    end
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
