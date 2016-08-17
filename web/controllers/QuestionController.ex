defmodule GithubflowApi.QuestionSerializer do
  use JaSerializer

  location "/questions/:id"
  attributes [:prompt, :complete, :responses]
end

defmodule GithubflowApi.QuestionController do
  use GithubflowApi.Web, :controller
  alias GithubflowApi.DecisionTree

  def index(conn, _params) do
    data =  DecisionTree.find 1

    res_data = GithubflowApi.QuestionSerializer.format(data, conn)
    # |> Poison.encode!

    json(conn, res_data)
  end

end
