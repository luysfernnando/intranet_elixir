defmodule IntranetElixirWeb.Admin.UserHTML do
  @moduledoc """
  This module contains pages rendered by UserController.

  See the `user_html` directory for all templates available.
  """
  use IntranetElixirWeb, :html

  import Phoenix.HTML.Link
  import Phoenix.HTML.Form
  import IntranetElixirWeb.ViewHelpers

  embed_templates "user_html/*"
end
