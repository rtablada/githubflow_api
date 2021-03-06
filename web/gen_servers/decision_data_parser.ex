defmodule GithubflowApi.DecisionTreeDataParser do
  def data do
    File.read!("data.json")
    |> Poison.decode!(keys: :atoms)
  end

  def parse_question(json) do
    %{
      prompt: json.prompt,
      responses: Enum.map(json.children, fn child -> child.answer end),
      complete: 0 == length(json.children)
    }
  end

  def find_root do
    parse_question data
  end

  def find_question(tree, from_prompt, response) do
    if 0 == length(tree.children) do
      {:not_found}
    end

    case tree.prompt do
      ^from_prompt ->
        possible = Enum.filter(tree.children, fn child -> child.answer == response end)
        |> List.first

        parse_question possible
      _ ->
        Enum.reduce_while(tree.children, nil, fn child, accum ->
          result = find_question(child, from_prompt, response)

          unless {:not_found} == result, do: {:halt, result}, else: {:cont, accum}
        end)
    end
  end

  def find_question(from_prompt, "yes") do
    find_question data(), from_prompt, "yes"
  end

  def find_question(from_prompt, "no") do
    find_question data(), from_prompt, "no"
  end

  def find_question(from_prompt, _) do
    {:error, "Invalid binary response"}
  end
end
