defmodule GithubflowApi.Repo.Migrations.CreateAnswer do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add :text, :string
      add :from_id, references(:prompts, on_delete: :nothing)
      add :to_id, references(:prompts, on_delete: :nothing)

      timestamps
    end
    create index(:answers, [:from_id])
    create index(:answers, [:to_id])

  end
end
