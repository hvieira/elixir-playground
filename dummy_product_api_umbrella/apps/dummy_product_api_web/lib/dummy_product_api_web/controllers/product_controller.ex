defmodule DummyProductApiWeb.ProductController do
  use DummyProductApiWeb, :controller

  alias DummyProductApi.ProductRegistry

  action_fallback DummyProductApiWeb.ErrorController

  def create(conn, params) do
    user = conn.assigns[:current_user]

    with {:ok, product} <- ProductRegistry.create_product(user, params) do
      render(conn, "product.json", product: product)
    else
      {:error, :invalid_product_attributes} ->
        {:error, :bad_request}

      _err ->
        {:error, :internal_server_error}
    end
  end

  def update(conn, params) do
    user = conn.assigns[:current_user]

    product_id = conn.path_params["id"]

    with {:ok, product} <- ProductRegistry.update_product(user, product_id, params) do
      render(conn, "product.json", product: product)
    else
      {:error, :user_not_owner} ->
        {:error, :forbidden}

      {:error, :invalid_product_attributes} ->
        {:error, :bad_request}

      _err ->
        {:error, :internal_server_error}
    end
  end
end
