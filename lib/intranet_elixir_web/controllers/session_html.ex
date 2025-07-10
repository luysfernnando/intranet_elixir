defmodule IntranetElixirWeb.SessionHTML do
  @moduledoc """
  This module contains pages rendered by SessionController.

  See the `session_html` directory for all templates available.
  """
  use IntranetElixirWeb, :html

  import Phoenix.HTML.Form

  embed_templates "session_html/*"
end
