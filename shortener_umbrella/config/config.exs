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
config :shortener,
  ecto_repos: [Shortener.Repo]

config :shortener_web,
  ecto_repos: [Shortener.Repo],
  generators: [context_app: :shortener]

# Configures the endpoint
config :shortener_web, ShortenerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "v3Qek/rmPEV6sayK4S683TA85eMPC+Bsu0O1j7Tiyob4m8aUlJtFLzjJDdmkwUdv",
  render_errors: [view: ShortenerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Shortener.PubSub,
  live_view: [signing_salt: "Jd1nkXBG"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
