defmodule IntranetElixir.Settings.Theme do
  use Ecto.Schema
  import Ecto.Changeset

  schema "themes" do
    field :name, :string
    field :primary_color, :string
    field :secondary_color, :string
    field :accent_color, :string
    field :logo_url, :string
    field :favicon_url, :string
    field :active, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(theme, attrs) do
    theme
    |> cast(attrs, [:name, :primary_color, :secondary_color, :accent_color, :logo_url, :favicon_url, :active])
    |> validate_required([:name, :primary_color, :secondary_color, :accent_color])
    |> validate_format(:primary_color, ~r/^#[0-9a-fA-F]{6}$/)
    |> validate_format(:secondary_color, ~r/^#[0-9a-fA-F]{6}$/)
    |> validate_format(:accent_color, ~r/^#[0-9a-fA-F]{6}$/)
  end
end
