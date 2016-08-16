defmodule GithubflowApi.Router do
  use GithubflowApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", GithubflowApi do
    pipe_through :api
  end
end
