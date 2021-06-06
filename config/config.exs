# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :nfl_rushing,
  ecto_repos: [NflRushing.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :nfl_rushing, NflRushingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "RlhoCBVNVpoq6sfFFBDW00wkTJBOl9Y3105kqTAaKsfp3qLgF7jdqcLE1em+8cWE",
  render_errors: [view: NflRushingWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: NflRushing.PubSub,
  live_view: [signing_salt: "HAQRnuRP"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
