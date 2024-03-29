defmodule DummyProductApiWeb.Auth.JWTTest do
  use ExUnit.Case, async: true

  alias DummyProductApiWeb.Auth.JWT

  @default_test_signer :new_signer
  @bad_audience "another_site.org"

  test "create valid tokens" do
    claims = %{}
    {:ok, token_str, claims} = JWT.generate_and_sign(claims, @default_test_signer)

    assert token_str != nil
    assert claims["jti"] != nil
    assert claims["aud"] == Application.get_env(:dummy_product_api_web, :audience)
    assert claims["iss"] == Application.get_env(:dummy_product_api_web, :audience)
    # not before + ttl equals expiration
    assert claims["nbf"] + 60 * 60 == claims["exp"]
    assert_in_delta claims["iat"], :os.system_time(:seconds), 10
  end

  test "can verify and validate signatures from generated jwts" do
    claims = %{}
    {:ok, token_str, generated_claims} = JWT.generate_and_sign(claims, @default_test_signer)

    {:ok, claims} = JWT.verify_and_validate(token_str, @default_test_signer)

    assert claims == generated_claims
  end

  test "can verify and validate jwts with bad signature" do
    bad_token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJhdWQiOiJkdW1teV9wcm9kdWN0LmNvbSIsImlzcyI6ImR1bW15X3Byb2R1Y3QuY29tIn0.4GPy1nvnqkjiE-rCJ5Yml0ZIPBAx5J9LHpY9G16LVA8"

    {result, error_details} = JWT.verify_and_validate(bad_token, @default_test_signer)
    assert result == :error
    assert error_details == :signature_error
  end

  test "can verify and validate jwts with bad audience" do
    {:ok, token_str, _} = JWT.generate_and_sign(%{"aud" => @bad_audience}, @default_test_signer)

    {result, error_details} = JWT.verify_and_validate(token_str, @default_test_signer)
    assert result == :error
    assert error_details == [message: "Invalid token", claim: "aud", claim_val: @bad_audience]
  end

  test "can verify and validate expired jwts" do
    exp_override = Joken.current_time() - 10
    {:ok, token_str, _} = JWT.generate_and_sign(%{"exp" => exp_override}, @default_test_signer)

    {result, error_details} = JWT.verify_and_validate(token_str, @default_test_signer)
    assert result == :error
    assert error_details == [message: "Invalid token", claim: "exp", claim_val: exp_override]
  end

  test "can verify and validate not yet valid (not before) jwts" do
    nbf_override = Joken.current_time() + 10
    {:ok, token_str, _} = JWT.generate_and_sign(%{"nbf" => nbf_override}, @default_test_signer)

    {result, error_details} = JWT.verify_and_validate(token_str, @default_test_signer)
    assert result == :error
    assert error_details == [message: "Invalid token", claim: "nbf", claim_val: nbf_override]
  end

  test "verify token through valid kid(s)" do
    {:ok, token_str_signed_with_new_key, _} = JWT.generate_and_sign(%{}, :new_signer)
    {:ok, token_str_signed_with_old_key, _} = JWT.generate_and_sign(%{}, :old_signer)

    {:ok, _claims} = JWT.verify_and_validate(token_str_signed_with_new_key)
    {:ok, _claims} = JWT.verify_and_validate(token_str_signed_with_old_key)
  end

  test "verify tokens that have not been signed with valid signers" do
    {:ok, token_str, _} = JWT.generate_and_sign(%{}, Joken.Signer.create("HS256", "s3cret"))

    assert JWT.verify_and_validate(token_str) == {:error, :signature_error}
  end
end
