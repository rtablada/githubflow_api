defmodule GithubflowApi.Router do
  use GithubflowApi.Web, :router

  pipeline :api do
    plug :accepts, ["json-api", "json"]
  end

  scope "/api", GithubflowApi do
    pipe_through :api

    get "/questions/start", QuestionController, :index
  end
end
