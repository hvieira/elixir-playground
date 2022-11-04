defmodule DummyProductApiWeb.UserControllerIntegrationTest do
  use DummyProductApiWeb.ConnCase, async: true

  @moduletag :integration

  @uuid_regex ~r/^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$/

  test "sign up users", %{conn: conn} do
    conn =
      post(conn, "/api/users", %{name: "John Doe", username: "sr_john", password: "superseKretz"})

    %{
      "data" => %{
        "id" => user_id,
        "name" => "John Doe",
        "username" => "sr_john"
      }
    } = json_response(conn, 200)

    assert String.match?(user_id, @uuid_regex)
  end

  # TODO check property testing for this sort of structure input validation
  test "sign up users - bad request - no name", %{conn: conn} do
    conn = post(conn, "/api/users", %{username: "sr_john", password: "superseKretz"})

    assert json_response(conn, 400) == %{
             "message" => "Bad request"
           }
  end

  test "sign up users - bad request - no username", %{conn: conn} do
    conn = post(conn, "/api/users", %{name: "John Doe", password: "superseKretz"})

    assert json_response(conn, 400) == %{
             "message" => "Bad request"
           }
  end

  test "sign up users - bad request - no password", %{conn: conn} do
    conn = post(conn, "/api/users", %{name: "John Doe", username: "sr_john"})

    assert json_response(conn, 400) == %{
             "message" => "Bad request"
           }
  end
end
