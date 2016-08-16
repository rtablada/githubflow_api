ExUnit.start

Mix.Task.run "ecto.create", ~w(-r GithubflowApi.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r GithubflowApi.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(GithubflowApi.Repo)

