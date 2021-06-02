# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :nomatic,
  ecto_repos: [Nomatic.Repo]

# Configures the endpoint
config :nomatic, NomaticWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "uUYO8L0gw1SRh5zlf3oPsdnUVbRrx1k/urpEpbmmwDNhbjZflBf9Q+1nII99lW+I",
  render_errors: [view: NomaticWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Nomatic.PubSub,
  live_view: [signing_salt: "6umKD4yx"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
