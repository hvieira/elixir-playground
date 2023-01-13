defmodule DummyProductApiWeb.Auth.JWTTest do
  use ExUnit.Case, async: true

  alias DummyProductApiWeb.Auth.JWT

  test "create valid tokens" do
    {:ok, token_str, claims} = JWT.generate_and_sign()

    assert token_str !=nil
    assert claims["jti"] != nil
    assert claims["aud"] == Application.get_env(:dummy_product_api_web, :audience)
    assert claims["iss"] == Application.get_env(:dummy_product_api_web, :audience)
    # not before equals expiration + ttl
    assert claims["nbf"] + (60 * 60) == claims["exp"]
    assert_in_delta claims["iat"], :os.system_time(:seconds), 10
  end

end
