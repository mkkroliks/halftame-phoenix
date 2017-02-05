# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :halftame,
  ecto_repos: [Halftame.Repo]

# Configures the endpoint
config :halftame, Halftame.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3A9rLSDJp25+YWZAAqyLpFICx/glTzwCJZaalmc/I1+2PCPFM9/kU9RQxqzgk8bZ",
  render_errors: [view: Halftame.ErrorView, accepts: ~w(json)],
  pubsub: [name: Halftame.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  hooks: GuardianDb,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "Halftame",
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true, # optional
  secret_key: "lksdjowiurowieurlkjsdlwwer",
  serializer: Halftame.GuardianSerializer

config :guardian_db, GuardianDb,
  repo: Halftame.Repo,
  schema_name: "tokens"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
