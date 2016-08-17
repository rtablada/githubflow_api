defmodule GithubflowApi.AnswerController do
  use GithubflowApi.Web, :controller

  alias GithubflowApi.Answer
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    answers = Repo.all(Answer)
    render(conn, "index.json-api", data: answers)
  end

  def create(conn, %{"data" => data = %{"type" => "answer", "attributes" => _answer_params}}) do
    changeset = Answer.changeset(%Answer{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, answer} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", answer_path(conn, :show, answer))
        |> render("show.json-api", data: answer)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(GithubflowApi.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    answer = Repo.get!(Answer, id)
    render(conn, "show.json-api", data: answer)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "answer", "attributes" => _answer_params}}) do
    answer = Repo.get!(Answer, id)
    changeset = Answer.changeset(answer, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, answer} ->
        render(conn, "show.json-api", data: answer)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(GithubflowApi.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    answer = Repo.get!(Answer, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(answer)

    send_resp(conn, :no_content, "")
  end

end
