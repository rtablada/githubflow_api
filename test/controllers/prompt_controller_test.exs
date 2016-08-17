defmodule GithubflowApi.PromptControllerTest do
  use GithubflowApi.ConnCase

  alias GithubflowApi.Prompt
  alias GithubflowApi.Repo

  @valid_attrs %{complete: true, text: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end
  
  defp relationships do
    %{}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, prompt_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    prompt = Repo.insert! %Prompt{}
    conn = get conn, prompt_path(conn, :show, prompt)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{prompt.id}"
    assert data["type"] == "prompt"
    assert data["attributes"]["text"] == prompt.text
    assert data["attributes"]["complete"] == prompt.complete
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, prompt_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, prompt_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "prompt",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Prompt, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, prompt_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "prompt",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    prompt = Repo.insert! %Prompt{}
    conn = put conn, prompt_path(conn, :update, prompt), %{
      "meta" => %{},
      "data" => %{
        "type" => "prompt",
        "id" => prompt.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Prompt, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    prompt = Repo.insert! %Prompt{}
    conn = put conn, prompt_path(conn, :update, prompt), %{
      "meta" => %{},
      "data" => %{
        "type" => "prompt",
        "id" => prompt.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    prompt = Repo.insert! %Prompt{}
    conn = delete conn, prompt_path(conn, :delete, prompt)
    assert response(conn, 204)
    refute Repo.get(Prompt, prompt.id)
  end

end
