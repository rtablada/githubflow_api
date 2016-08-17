defmodule GithubflowApi.PromptController do
  use GithubflowApi.Web, :controller

  alias GithubflowApi.Prompt
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def start(conn, _params) do
    prompt = Repo.get!(Prompt, 1)
    prompt = Repo.preload prompt, :answers
    render(conn, "show.json-api", data: prompt)
  end

  def index(conn, _params) do
    prompts = Repo.all(Prompt)
    prompts = Repo.preload prompts, :answers
    render(conn, "index.json-api", data: prompts)
  end

  def create(conn, %{"data" => data = %{"type" => "prompt", "attributes" => _prompt_params}}) do
    changeset = Prompt.changeset(%Prompt{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, prompt} ->
        prompt = Repo.preload prompt, :answers

        conn
        |> put_status(:created)
        |> put_resp_header("location", prompt_path(conn, :show, prompt))
        |> render("show.json-api", data: prompt)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(GithubflowApi.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    prompt = Repo.get!(Prompt, id)
    prompt = Repo.preload prompt, :answers

    render(conn, "show.json-api", data: prompt)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "prompt", "attributes" => _prompt_params}}) do
    prompt = Repo.get!(Prompt, id)
    changeset = Prompt.changeset(prompt, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, prompt} ->
        prompt = Repo.preload prompt, :answers

        render(conn, "show.json-api", data: prompt)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(GithubflowApi.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    prompt = Repo.get!(Prompt, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(prompt)

    send_resp(conn, :no_content, "")
  end

end
