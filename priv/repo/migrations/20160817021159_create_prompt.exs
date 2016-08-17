defmodule GithubflowApi.Repo.Migrations.CreatePrompt do
  use Ecto.Migration

  def change do
    create table(:prompts) do
      add :text, :string
      add :complete, :boolean, default: false

      timestamps
    end

  end
end
