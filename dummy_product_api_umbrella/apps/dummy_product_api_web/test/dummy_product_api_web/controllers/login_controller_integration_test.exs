defmodule DummyProductApiWeb.LoginControllerIntegrationTest do
  use DummyProductApiWeb.ConnCase, async: true

  @moduletag :integration

  alias DummyProductApiWeb.Auth.JWT

  test "user log in", %{conn: conn} do
    username = "ms_jane"
    password = "superseKretz"

    response =
      post(conn, "/api/users", %{name: "Jane Doe", username: username, password: password})

    %{
      "data" => %{
        "id" => user_id
      }
    } = json_response(response, 200)

    response = post(conn, "/api/login", %{username: username, password: password})

    %{
      "data" => %{
        "token" => token_str
      }
    } = json_response(response, 200)

    assert match?({:ok, %{"sub" => ^user_id}}, JWT.verify_and_validate(token_str, :new_signer))
  end
end
