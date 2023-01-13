defmodule DummyProductApiWeb.Auth.JWT do

  use Joken.Config

  @one_hour_in_seconds 60 * 60

  @audience Application.get_env(:dummy_product_api_web, :audience)

  def token_config, do: default_claims(
    default_exp: @one_hour_in_seconds,
    aud: @audience,
    iss: @audience
  )

end
