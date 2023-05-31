defmodule DummyProductApiWeb.ProductController do
  use DummyProductApiWeb, :controller

  alias DummyProductApi.ProductRegistry

  action_fallback DummyProductApiWeb.ErrorController

  def create(conn, params) do

    user = conn.assigns[:current_user]

    with {:ok, product} <- ProductRegistry.create_product(user, params) do
      render(conn, "create.json", product: product)
    else
      {:error, :invalid_product_attributes} ->
        {:error, :bad_request}

      _err ->
        {:error, :internal_server_error}
    end
  end
end
