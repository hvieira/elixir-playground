defmodule DummyProductApiWeb.UserController do
  use DummyProductApiWeb, :controller

  alias DummyProductApi.User
  alias DummyProductApi.UserStore

  action_fallback DummyProductApiWeb.ErrorController

  @user_store Application.get_env(:dummy_product_api, :user_store)

  def create(conn, %{"name" => _} = params) do
    {:ok, user} = @user_store.create_user(params)
    render(conn, "create.json", user: user)
  end

  def create(conn, _params) do
    {:error, :bad_request}
  end
end
