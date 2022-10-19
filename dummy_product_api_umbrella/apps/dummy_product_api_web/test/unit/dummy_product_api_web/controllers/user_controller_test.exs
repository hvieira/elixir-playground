defmodule DummyProductApiWeb.UserControllerTest do
  use DummyProductApiWeb.ConnCase, async: true
  import Mox

  setup :verify_on_exit!

  test "create users - error when saving user", %{conn: conn} do
    DummyProductApi.UserStoreMock
    |> expect(:create_user, fn (_user_params) -> {:error, "oh noes"} end)

    response = post(conn, "/api/users", %{name: "Senor John"})

    assert json_response(response, 500) == %{
             "message" => "Internal server error"
           }
  end
end
