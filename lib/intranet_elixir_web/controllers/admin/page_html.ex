defmodule IntranetElixirWeb.Admin.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use IntranetElixirWeb, :html

  import Phoenix.HTML.Link

  embed_templates "page_html/*"
end
