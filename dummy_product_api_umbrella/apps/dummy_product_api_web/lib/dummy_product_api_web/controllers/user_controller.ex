defmodule DummyProductApiWeb.UserController do
  use DummyProductApiWeb, :controller

  alias DummyProductApi.UserRegistry

  action_fallback DummyProductApiWeb.ErrorController

  def create(conn, params) do
    with {:ok, user} <- UserRegistry.signup_user(params) do
      render(conn, "create.json", user: user)
    else
      {:error, :invalid_user_attributes} ->
        {:error, :bad_request}

      err ->
        {:error, :internal_server_error}
    end
  end

end
