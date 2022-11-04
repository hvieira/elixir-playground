defmodule DummyProductApiWeb.UserControllerTest do
  use DummyProductApiWeb.ConnCase, async: true
  import Mox
  import DummyProductApiWeb.MocksHelper

  setup [:setup_mocks, :verify_on_exit!]

  test "create users - error when saving user", %{conn: conn} do
    Application.put_env(:dummy_product_api, :user_store, DummyProductApi.UserStoreMock)

    DummyProductApi.UserStoreMock
    |> expect(:create_user, fn _user_params -> {:error, "oh noes"} end)

    response = post(conn, "/api/users", %{name: "Senor John"})

    assert json_response(response, 500) == %{
             "message" => "Internal server error"
           }
  end
end
