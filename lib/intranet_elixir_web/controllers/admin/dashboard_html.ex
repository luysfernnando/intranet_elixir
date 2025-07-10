defmodule IntranetElixirWeb.Admin.DashboardHTML do
  @moduledoc """
  This module contains pages rendered by DashboardController.

  See the `dashboard_html` directory for all templates available.
  """
  use IntranetElixirWeb, :html

  import Phoenix.HTML.Link

  embed_templates "dashboard_html/*"
end
