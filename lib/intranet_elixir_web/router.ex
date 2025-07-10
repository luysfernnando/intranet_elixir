defmodule IntranetElixirWeb.Router do
  use IntranetElixirWeb, :router

  import IntranetElixirWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {IntranetElixirWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Guardian.Plug.Pipeline,
      module: IntranetElixir.Guardian,
      error_handler: IntranetElixirWeb.AuthErrorHandler

    plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
    plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
    plug Guardian.Plug.LoadResource, allow_blank: true
    plug :fetch_current_user
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :admin_required do
    plug IntranetElixirWeb.Plugs.RequireRole, [:admin, :supervisor, :editor, :estagiario]
  end

  # Public routes
  scope "/", IntranetElixirWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    get "/posts", PostController, :index
    get "/posts/:slug", PostController, :show
    get "/pages", PageController, :list
    get "/pages/:slug", PageController, :show
  end

  # Auth routes (no auth pipeline needed)
  scope "/", IntranetElixirWeb do
    pipe_through :browser

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete
  end

  # Admin routes
  scope "/admin", IntranetElixirWeb.Admin, as: :admin do
    pipe_through [:browser, :auth, :ensure_auth, :admin_required]

    get "/", DashboardController, :index

    # User management (admin only)
    resources "/users", UserController, except: [:show]

    # Posts management
    resources "/posts", PostController
    patch "/posts/:id/approve", PostController, :approve

    # Pages management
    resources "/pages", PageController
    patch "/pages/:id/approve", PageController, :approve

    # Theme management (admin only)
    resources "/themes", ThemeController
    patch "/themes/:id/activate", ThemeController, :activate
  end

  # Other scopes may use custom stacks.
  scope "/api", IntranetElixirWeb do
    pipe_through :api
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:intranet_elixir, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: IntranetElixirWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
