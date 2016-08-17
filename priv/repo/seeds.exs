defmodule Sedder.Seed do
  def make_prompt(data) do
    %{id: id} = GithubflowApi.Repo.insert!(%GithubflowApi.Prompt{
      text: data.prompt,
      complete: 0 == length(data.children)
    })

    id
  end
  def make_from_tree(tree, parent_id) do
    id = make_from_tree tree

    GithubflowApi.Repo.insert!(%GithubflowApi.Answer{
      text: tree.answer,
      from_id: parent_id,
      to_id: id
    })
  end

  def make_from_tree(tree) do
    id = make_prompt tree

    for child <- tree.children, do: make_from_tree(child, id)

    id
  end
end

data = File.read!("data.json")
  |> Poison.decode!(keys: :atoms)

Sedder.Seed.make_from_tree data
