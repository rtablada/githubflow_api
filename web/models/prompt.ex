defmodule GithubflowApi.Prompt do
  use GithubflowApi.Web, :model

  schema "prompts" do
    field :text, :string
    field :complete, :boolean, default: false
    has_many :answers, GithubflowApi.Answer, foreign_key: :from_id

    timestamps
  end

  @required_fields ~w(text complete)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
