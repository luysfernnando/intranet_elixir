import Config

# Configure your database
config :intranet_elixir, IntranetElixir.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "intranet_elixir_prod",
  pool_size: 15

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
