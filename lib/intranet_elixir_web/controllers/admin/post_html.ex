defmodule IntranetElixirWeb.Admin.PostHTML do
  @moduledoc """
  This module contains pages rendered by PostController.

  See the `post_html` directory for all templates available.
  """
  use IntranetElixirWeb, :html

  import Phoenix.HTML.Link
  import Phoenix.HTML.Form
  import IntranetElixirWeb.ViewHelpers

  embed_templates "post_html/*"
end
