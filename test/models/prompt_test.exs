defmodule GithubflowApi.PromptTest do
  use GithubflowApi.ModelCase

  alias GithubflowApi.Prompt

  @valid_attrs %{complete: true, text: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Prompt.changeset(%Prompt{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Prompt.changeset(%Prompt{}, @invalid_attrs)
    refute changeset.valid?
  end
end
