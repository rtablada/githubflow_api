use Mix.Config

config :githubflow_api, GithubflowApi.Endpoint,
  http: [port: {:system, "PORT"}],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  url: [host: "githubflow-decision-app.herokuapp.com", port: 443],
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :githubflow_api, GithubflowApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: 20

# Do not print debug messages in production
config :logger, level: :info
