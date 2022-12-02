defmodule DummyProductApiWeb.Auth.JWTTest do
  use ExUnit.Case, async: true

  alias DummyProductApiWeb.Auth.JWT

  @dummy_jwt "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"


#  test "decoding a JWT" do
#    jwt = JWT.verify(@dummy_jwt, "")
#  end

  test "create token" do
    JWT.generate_and_sign()
  end
end
