import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod configuration.

# Start the phoenix server if environment is set and running in a release
if System.get_env("PHX_SERVER") && System.get_env("RELEASE_NAME") do
  config :intranet_elixir, IntranetElixirWeb.Endpoint, server: true
end

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6") in ~w(true 1), do: [:inet6], else: []

  config :intranet_elixir, IntranetElixir.Repo,
    # ssl: true,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :intranet_elixir, IntranetElixirWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base

  # Configure your mailer
  #
  # ## Using an adapter
  #
  # requires you to provide the secret key base.
  # You can generate one by calling: mix phx.gen.secret
  #
  # ## TLS (Transport Layer Security)
  #
  # Historically, emails were sent over SMTP without encryption. Email content
  # was sent as plain text, and passwords were sent in plain text as well.
  # TLS can be used to encrypt the connection to the SMTP server and protect
  # these credentials.
  #
  # To enable TLS, it is typically required to set `:tls` to `:if_available` or `:always`.
  # Furthermore, you might need to set `:ssl_verify` to `:verify_none` and
  # `:tls_verify` to `:verify_none` depending on your SMTP server configuration.
  #
  # For Gmail, the typical setup is:
  #
  #     config :intranet_elixir, IntranetElixir.Mailer,
  #       adapter: Swoosh.Adapters.SMTP,
  #       relay: "smtp.gmail.com",
  #       username: System.get_env("SMTP_USERNAME"),
  #       password: System.get_env("SMTP_PASSWORD"),
  #       port: 587,
  #       tls: :if_available,
  #       auth: :always,
  #       retries: 2
  #
  # For a local SMTP server, here's an example configuration:
  #
  #     config :intranet_elixir, IntranetElixir.Mailer,
  #       adapter: Swoosh.Adapters.SMTP,
  #       relay: "localhost",
  #       port: 1025,
  #       username: nil,
  #       password: nil,
  #       tls: :if_available,
  #       allowed_tls_versions: [:"tlsv1.2"],
  #       ssl_verify: :verify_none,
  #       auth: :if_available

  # Configure Guardian secret key
  guardian_secret_key =
    System.get_env("GUARDIAN_SECRET_KEY") ||
      raise """
      environment variable GUARDIAN_SECRET_KEY is missing.
      You can generate one by calling: mix guardian.gen.secret
      """

  config :intranet_elixir, IntranetElixir.Guardian,
    secret_key: guardian_secret_key
end
