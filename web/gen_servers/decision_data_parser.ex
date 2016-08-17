defmodule GithubflowApi.DecisionTreeDataParser do
  def data do
    %{
      prompt: "Is this a new feature?",
      children: [
        %{
          answer: "yes",
          prompt: "Do you have a feature branch?",
          children: [
            %{
              answer: "yes",
              prompt: "Are there any changes to be committed?",
              children: [
                %{
                  answer: "yes",
                  prompt: "`git add . && git commit`",
                  children: [
                  ],
                },
                %{
                  answer: "no",
                  prompt: "Have you pushed to your fork?",
                  children: [
                    %{
                      answer: "yes",
                      prompt: "Have you created a pull request to the organization?",
                      children: [
                        %{
                          answer: "yes",
                          prompt: "Is your feature done?",
                          children: [
                            %{
                              answer: "yes",
                              prompt: "Have you had a team member code review your pull-request?",
                              children: [
                                %{
                                  answer: "yes",
                                  prompt: "Has your team member merge the pull request?",
                                  children: [
                                  ],
                                },
                                %{
                                  answer: "no",
                                  prompt: "Is your branch up to date with `upstream master`?",
                                  children: [
                                    %{
                                      answer: "yes",
                                      prompt: "Have a sit down with your team member and review the pull request",
                                      children: [],
                                    },
                                    %{
                                      answer: "no",
                                      prompt: "`git pull upstream master`",
                                      children: [],
                                    },
                                  ],
                                },

                              ],
                            },
                          ],
                        },
                        %{
                          answer: "no",
                          prompt: "`hub pull-request`",
                          children: [],
                        },
                      ],
                    },
                    %{
                      answer: "no",
                      prompt: "`git push origin HEAD` (same as `git push origin feature/<feature-name>`)",
                      children: [],
                    },
                  ],
                },
              ],
            },
          ]
        },
      ]
    }
  end

  def find_question(tree, from_prompt, response) do
    if 0 == length(tree.children) do
      {:not_found}
    end

    case tree.prompt do
      ^from_prompt ->
        possible = Enum.filter(tree.children, fn child -> child.answer == response end)
        |> List.first

        %{
          prompt: possible.prompt,
          responses: Enum.map(possible.children, fn child -> child.answer end),
          complete: 0 == length(possible.children)
        }
      _ ->
        Enum.reduce(tree.children, nil, fn child, accum ->
          result = find_question(child, from_prompt, response)

          unless {:not_found} == result, do: result, else: accum
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
