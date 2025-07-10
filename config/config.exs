import Config

# General application configuration
config :intranet_elixir,
  ecto_repos: [IntranetElixir.Repo]

# Configures the endpoint
config :intranet_elixir, IntranetElixirWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: IntranetElixirWeb.ErrorHTML, json: IntranetElixirWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: IntranetElixir.PubSub,
  live_view: [signing_salt: "YourSigningSalt123456789012345678901234567890"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :intranet_elixir, IntranetElixir.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.0",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Guardian configuration
config :intranet_elixir, IntranetElixir.Guardian,
  issuer: "intranet_elixir",
  secret_key: "YourGuardianSecretKey123456789012345678901234567890123456789012345678901234567890"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
