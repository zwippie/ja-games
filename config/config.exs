# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :klikker,
  ecto_repos: [Klikker.Repo]

# Configures the endpoint
config :klikker, KlikkerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Ln5WG6nz3LYIkFt7rhmawH6Fkb5U+gquVNQDD32X922kwobOq2TfFLCRDhDG4G0A",
  render_errors: [view: KlikkerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Klikker.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :klikker, Klikker.Auth.Guardian,
       issuer: "klikker",
       secret_key: "AyNT4S41F6T9LGt3olV+0EJPkGU/mjXhsvnmAH+3vy+Nxi3nGVZwdN3jCEbZxH+x"

config :klikker, Klikker.Auth.Pipeline,
  module: Klikker.Auth.Guardian,
  error_handler: Klikker.Auth.ErrorHandler

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
