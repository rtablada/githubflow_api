defmodule GithubflowApi.AnswerView do
  use GithubflowApi.Web, :view
  use JaSerializer.PhoenixView

  attributes [:text]

  has_one :from,
    field: :from_id,
    type: "prompt"
  has_one :to,
    field: :to_id,
    type: "prompt"

end
