defmodule GithubflowApi.QuestionSerializer do
  use JaSerializer

  location "/questions/:id"
  attributes [:prompt, :complete, :responses]
end

defmodule GithubflowApi.QuestionController do
  use GithubflowApi.Web, :controller

  def index(conn, _params) do
    data =  %{
      id: 1,
      prompt: "Is this a new feature?",
      complete: false,
      responses: [
        %{
          text: "Yes",
          question: 2
        },
        %{
          text: "No",
          question: 3
        }
      ]
    }

    res_data = GithubflowApi.QuestionSerializer.format(data, conn)
    # |> Poison.encode!

    json(conn, res_data)
  end

end
