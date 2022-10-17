defmodule DummyProductApiWeb.UserController do
  use DummyProductApiWeb, :controller

  alias DummyProductApi.User
  alias DummyProductApi.UserStore

  action_fallback DummyProductApiWeb.ErrorController

  def create(conn, %{"name" => _} = params) do
    with {:ok, user} <- user_store().create_user(params) do
      render(conn, "create.json", user: user)
    else
      {:error, message} -> {:error, :internal_server_error}
    end
  end

  def create(conn, _params) do
    {:error, :bad_request}
  end

  def user_store() do
    Application.get_env(:dummy_product_api, :user_store)
  end
end
