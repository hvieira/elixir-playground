defmodule DummyProductApiWeb.UserController do
  use DummyProductApiWeb, :controller

  alias DummyProductApi.User
  alias DummyProductApi.UserStore

  action_fallback DummyProductApiWeb.ErrorController

  def create(conn, %{"name" => _} = params) do
    {:ok, user} = UserStore.create_user(params)
    render(conn, "create.json", user: user)
  end

  def create(conn, params) do
    {:error, :bad_request}
  end
end
