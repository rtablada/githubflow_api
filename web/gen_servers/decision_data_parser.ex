defmodule GithubflowApi.DecisionTreeDataParser do
  def data do
    %{
      question_text: "Is this a new feature?",
      children: [
        %{
          answer: "yes",
          question_text: "Do you have a feature branch?",
          children: [
            %{
              answer: "yes",
              question_text: "Are there any changes to be committed?",
              children: [
                %{
                  answer: "yes",
                  response_text: "`git add . && git commit`",
                  children: [
                  ],
                },
                %{
                  answer: "no",
                  question_text: "Have you pushed to your fork?",
                  children: [
                    %{
                      answer: "yes",
                      question_text: "Have you created a pull request to the organization?",
                      children: [
                        %{
                          answer: "yes",
                          question_text: "Is your feature done?",
                          children: [
                            %{
                              answer: "yes",
                              question_text: "Have you had a team member code review your pull-request?",
                              children: [
                                %{
                                  answer: "yes",
                                  question_text: "Has your team member merge the pull request?",
                                  children: [
                                  ],
                                },
                                %{
                                  answer: "no",
                                  question_text: "Is your branch up to date with `upstream master`?",
                                  children: [
                                    %{
                                      answer: "yes",
                                      response_text: "Have a sit down with your team member and review the pull request",
                                      children: [],
                                    },
                                    %{
                                      answer: "no",
                                      response_text: "`git pull upstream master`",
                                      children: [
                                      ],
                                    },
                                  ],
                                },

                              ],
                            },
                          ],
                        },
                        %{
                          answer: "no",
                          response_text: "`hub pull-request`",
                          children: [],
                        },
                      ],
                    },
                    %{
                      answer: "no",
                      response_text: "`git push origin HEAD` (same as `git push origin feature/<feature-name>`)",
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

  def find_question(tree, from_question_text, response) do
    case tree.question_text do
      ^from_question_text ->
        %{
          prompt: tree.question_text,
          responses: Enum.map(tree.children, fn child -> child.answer end),
          complete: 0 == length(tree.children)
        }
      _ ->
        find_question tree.children, from_question_text, response
    end
  end

  def find_question(from_question_text, "yes") do
    find_question data(), from_question_text, "yes"
  end

  def find_question(from_question_text, "no") do
    find_question data(), from_question_text, "no"
  end

  def find_question(from_question_text, _) do
    {:error, "Invalid binary response"}
  end
end
