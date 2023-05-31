defmodule DummyProductApiWeb.LoginControllerIntegrationTest do
  use DummyProductApiWeb.ConnCase, async: true

  @moduletag :integration

  # @uuid_regex ~r/^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$/

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

    # validate that the returned token is valid and verifiable and has the correct claims
    assert match?({:ok, %{"sub" => ^user_id}}, JWT.verify_and_validate(token_str, :new_signer))
  end
end
