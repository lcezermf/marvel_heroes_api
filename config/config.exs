# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :ten_ex_take_home,
  ecto_repos: [TenExTakeHome.Repo]

# Configures the endpoint
config :ten_ex_take_home, TenExTakeHomeWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: TenExTakeHomeWeb.ErrorHTML, json: TenExTakeHomeWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: TenExTakeHome.PubSub,
  live_view: [signing_salt: "bQy1pAiD"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :ten_ex_take_home, TenExTakeHome.Mailer, adapter: Swoosh.Adapters.Local

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
  version: "3.2.7",
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

# Real http client that allow to call the external apis
config :ten_ex_take_home, :http_client, HTTPoison

config :ten_ex_take_home, :marvel_client,
  adapter: TenExTakeHomeWeb.Clients.MarvelClient,
  base_url: "https://gateway.marvel.com/v1/public"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
