defmodule IntranetElixirWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered around the page layout.
  """
  use IntranetElixirWeb, :html

  # Import Phoenix.HTML for link/2 and other HTML helpers
  import Phoenix.HTML.Link

  embed_templates "layouts/*"
end
