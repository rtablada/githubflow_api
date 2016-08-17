defmodule GithubflowApi.DecisionTree do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: :decision_tree)
  end

  def find(id) do
    GenServer.call(:decision_tree, {:question, id})
  end

  def handle_call({:question, id}, _from, state) do
    case id do
      1 ->
        response = GithubflowApi.DecisionTreeDataParser.find_question("Is this a new feature?", "yes")

        {:reply, response, state}
      2 ->
        response = %{
          id: 1,
          prompt: "Is this a new feature?",
          complete: false,
          responses: ["Yes", "No"]
        }

        {:reply, response, state}
      _ ->
        {:reply, :error, state}
    end
  end

  def init(_options) do
    IO.puts "Start decision tree"
    {:ok, %{}}
  end
end
