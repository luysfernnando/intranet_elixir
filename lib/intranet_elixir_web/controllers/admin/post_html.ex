defmodule IntranetElixirWeb.Admin.PostHTML do
  @moduledoc """
  This module contains pages rendered by PostController.

  See the `post_html` directory for all templates available.
  """
  use IntranetElixirWeb, :html

  import Phoenix.HTML.Link
  import Phoenix.HTML.Form
  import IntranetElixirWeb.ViewHelpers

  # Helper functions for form values
  def categories_value(form) do
    case Phoenix.HTML.Form.input_value(form, :categories) do
      nil -> ""
      [] -> ""
      categories when is_list(categories) -> Enum.join(categories, ", ")
      categories when is_binary(categories) -> categories
      _ -> ""
    end
  end

  def tags_value(form) do
    case Phoenix.HTML.Form.input_value(form, :tags) do
      nil -> ""
      [] -> ""
      tags when is_list(tags) -> Enum.join(tags, ", ")
      tags when is_binary(tags) -> tags
      _ -> ""
    end
  end

  embed_templates "post_html/*"
end
