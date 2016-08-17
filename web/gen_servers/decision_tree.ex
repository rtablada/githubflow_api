defmodule GithubflowApi.DecisionTree do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: :decision_tree)
  end

  def find(id) do
    GenServer.call(:decision_tree, {:question, id})
  end

  def find(last_question, response) do
    GenServer.call(:decision_tree, {:response, last_question, response})
  end

  def handle_call({:response, last_question, response}, _from, state) do
    response = GithubflowApi.DecisionTreeDataParser.find_question(last_question, response)

    {:reply, response, state}
  end

  def handle_call({:question, id}, _from, state) do
    case id do
      1 ->
        response = GithubflowApi.DecisionTreeDataParser.find_question("Is this a new feature?", "yes")

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
