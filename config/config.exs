# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :jmunited,
  ecto_repos: [Jmunited.Repo]

config :jmunited_web,
  ecto_repos: [Jmunited.Repo],
  generators: [context_app: :jmunited]

# Configures the endpoint
config :jmunited_web, JmunitedWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "YUMj7caH/d9E4TeaYOc3mEzz93ZH/oOmUAMBwfVlPEFqeuPo49qzkYKEjDiFOcVg",
  render_errors: [view: JmunitedWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Jmunited.PubSub,
  live_view: [signing_salt: "VNNLjGUq"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :jmunited_web, JmunitedWeb.Guardian,
  issuer: "jmunited_web",
  secret_key: "uddmO2L1iNBLQtqAZZHBImqBVjHJD0LBgxe3xk71XUWNbCqcmMzI5rGylS4GmKFc" # paste input here

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :jmunited_web, JmunitedWeb.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: "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",
  hackney_opts: [
    recv_timeout: :timer.minutes(1),
    connect_timeout: :timer.minutes(1)
  ]

# config :jmunited_web, JmunitedWeb.Mailer,
#   adapter: Bamboo.LocalAdapter

config :jmunited_web, JmunitedWeb.Gettext,
  locales: ~w(en nl),
  default_locale: "en"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
