defmodule DummyProductApiWeb.Auth.ClientAuth do
  import Plug.Conn

  alias DummyProductApiWeb.Auth.JWT
  alias DummyProductApi.UserRegistry

  require Logger

  def fetch_user_info(conn, _opts) do
    with bearer_token_headers <- get_req_header(conn, "authorization"),
         {:ok, token} <- get_token_from_authentication_header_list(bearer_token_headers),
         {:ok, claims} <- JWT.verify_and_validate(token, :new_signer),
         {:ok, user} <- UserRegistry.get_user_by_id(claims["sub"]) do
      conn |> assign(:current_user, user)
    else
      :no_bearer_token ->
        conn

      err ->
        Logger.error("An error occurred during use fetching in the request", error_info: err)
        conn
    end
  end

  defp get_token_from_authentication_header_list([]), do: :no_bearer_token

  defp get_token_from_authentication_header_list([h | _t]) do
    token =
      h
      |> String.replace_leading("Bearer", "")
      |> String.trim_leading()

    {:ok, token}
  end

  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> halt()
      |> resp(401, "no valid credentials present in request")
    end
  end
end
