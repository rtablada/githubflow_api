defmodule GithubflowApi.PromptView do
  use GithubflowApi.Web, :view
  use JaSerializer.PhoenixView

  attributes [:text, :complete]

  has_many :answers,
    field: :answers,
    type: "answer"
end
