defmodule DummyProductApiWeb.Auth.JWT do
  use Joken.Config

  require Logger

  @one_hour_in_seconds 60 * 60

  @audience Application.get_env(:dummy_product_api_web, :audience)

  @signature_error {:error, :signature_error}
  @hook_signature_error {:halt, @signature_error}

  def token_config,
    do:
      default_claims(
        default_exp: @one_hour_in_seconds,
        aud: @audience,
        iss: @audience
      )

  @impl true
  def before_verify(_hook_options, {token, _signer}) do
    new_signer = Joken.Signer.parse_config(:new_signer)
    new_signer_kid = Joken.Signer.parse_config(:new_signer).jws.fields["kid"]

    old_signer = Joken.Signer.parse_config(:old_signer)
    old_signer_kid = Joken.Signer.parse_config(:old_signer).jws.fields["kid"]

    with {:ok, headers} <- Joken.peek_header(token),
         kid <- Map.get(headers, "kid") do
      case kid do
        ^new_signer_kid ->
          {:cont, {token, new_signer}}

        ^old_signer_kid ->
          {:cont, {token, old_signer}}

        # other key ids are not valid
        nil ->
          Logger.warning("No key id (kid) header present in token")
          @hook_signature_error

        kid ->
          Logger.warning("Key for JWT token not recognized #{kid}")
          @hook_signature_error
      end
    else
      _ -> @hook_signature_error
    end
  end
end
