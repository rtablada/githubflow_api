defmodule GithubflowApi.AnswerControllerTest do
  use GithubflowApi.ConnCase

  alias GithubflowApi.Answer
  alias GithubflowApi.Repo

  @valid_attrs %{text: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end
  
  defp relationships do 
    from = Repo.insert!(%GithubflowApi.From{})
    to = Repo.insert!(%GithubflowApi.To{})

    %{
      "from" => %{
        "data" => %{
          "type" => "from",
          "id" => from.id
        }
      },
      "to" => %{
        "data" => %{
          "type" => "to",
          "id" => to.id
        }
      },
    }
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, answer_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    answer = Repo.insert! %Answer{}
    conn = get conn, answer_path(conn, :show, answer)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{answer.id}"
    assert data["type"] == "answer"
    assert data["attributes"]["text"] == answer.text
    assert data["attributes"]["from_id"] == answer.from_id
    assert data["attributes"]["to_id"] == answer.to_id
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, answer_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, answer_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "answer",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Answer, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, answer_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "answer",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    answer = Repo.insert! %Answer{}
    conn = put conn, answer_path(conn, :update, answer), %{
      "meta" => %{},
      "data" => %{
        "type" => "answer",
        "id" => answer.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Answer, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    answer = Repo.insert! %Answer{}
    conn = put conn, answer_path(conn, :update, answer), %{
      "meta" => %{},
      "data" => %{
        "type" => "answer",
        "id" => answer.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    answer = Repo.insert! %Answer{}
    conn = delete conn, answer_path(conn, :delete, answer)
    assert response(conn, 204)
    refute Repo.get(Answer, answer.id)
  end

end
