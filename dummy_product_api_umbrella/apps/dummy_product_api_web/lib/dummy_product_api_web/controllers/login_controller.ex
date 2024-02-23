defmodule DummyProductApiWeb.LoginController do
  use DummyProductApiWeb, :controller

  alias DummyProductApi.UserRegistry
  alias DummyProductApiWeb.Auth.JWT

  action_fallback DummyProductApiWeb.ErrorController

  def login(conn, params) do
    # TODO validate structure - there's likely a better way to do this and/or a library for this
    %{"username" => username, "password" => password} = params

    with {:ok, user} <- UserRegistry.get_user_by_credentials(username, password),
         {:ok, token, _claims} <-
           JWT.generate_and_sign(
             %{sub: user.id},
             :new_signer
           ) do
      render(conn, "logged_in.json", %{token: token})
    else
      err ->
        err
    end
  end
end
