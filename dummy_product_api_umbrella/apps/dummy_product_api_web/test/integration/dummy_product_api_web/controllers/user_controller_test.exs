defmodule DummyProductApiWeb.UserControllerTest do
  use DummyProductApiWeb.ConnCase, async: true
  import Mox

  setup :verify_on_exit!

  @uuid_regex ~r/^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$/

  # integration tests
  test "create users", %{conn: conn} do
    conn = post(conn, "/api/users", %{name: "Senor John"})

    %{
      "data" => %{
        "id" => user_id,
        "name" => "Senor John"
      }
    } = json_response(conn, 200)

    # check id is a uuid
    assert String.match?(user_id, @uuid_regex)
  end

  test "create users - bad request - no name", %{conn: conn} do
    conn = post(conn, "/api/users", %{username: "Senor John"})

    assert json_response(conn, 400) == %{
             "message" => "Bad request"
           }
  end
end
