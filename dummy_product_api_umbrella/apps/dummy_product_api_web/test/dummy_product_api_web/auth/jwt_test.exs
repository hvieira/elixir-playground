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

  test "can verify signatures from generated jwts" do
    {:ok, token_str, generated_claims} = JWT.generate_and_sign()

    {:ok, claims} = JWT.verify(token_str)

    assert claims == generated_claims
  end

  test "can verify jwts with bad signature" do
    bad_token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJhdWQiOiJkdW1teV9wcm9kdWN0LmNvbSIsImlzcyI6ImR1bW15X3Byb2R1Y3QuY29tIn0.4GPy1nvnqkjiE-rCJ5Yml0ZIPBAx5J9LHpY9G16LVA8"

    {:error, error_msg} = JWT.verify(bad_token)

    assert error_msg == :signature_error
  end

  # TODO verify and/or validate audience

  # TODO not before and expiration tests to be done via https://hexdocs.pm/joken/Joken.html#current_time/0

end
