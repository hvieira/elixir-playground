defmodule DummyProductApiWeb.MocksHelper do
  def setup_mocks(_context) do
    Application.put_env(:dummy_product_api, :user_store, DummyProductApi.UserStoreMock)
    Application.put_env(:dummy_product_api, :product_store, DummyProductApi.ProductStoreMock)
  end
end
