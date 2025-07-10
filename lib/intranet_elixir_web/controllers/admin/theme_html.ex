defmodule IntranetElixirWeb.Admin.ThemeHTML do
  @moduledoc """
  This module contains pages rendered by ThemeController.

  See the `theme_html` directory for all templates available.
  """
  use IntranetElixirWeb, :html

  import Phoenix.HTML.Link

  embed_templates "theme_html/*"
end
