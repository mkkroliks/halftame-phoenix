use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :halftame,
  facebook_api_token: "EAADZAJLAaYN8BAHUxJKkoiZC1KWpTuFjzZCXRJIZCFmPgvFZBByiVzVRzsJ9RZCqVpF6ZBPEL6mH2gXrBog3P2yPjigEoFgqJ9F9C97Yi5Aay0kKZCZCZCsk9jO9eHQZC5bYKz9eji7NgZAXLNEUo5NrKrHFBFrQ4wfk7zzkuaQ4vys79XPAsqL4pNf8ATwhr4gxYRX10oMaixAW8tXEFpEPOlMWh1ODINyds80Z"

config :halftame, Halftame.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :halftame, Halftame.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "mk",
  password: "bleblebl",
  database: "halftame_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
