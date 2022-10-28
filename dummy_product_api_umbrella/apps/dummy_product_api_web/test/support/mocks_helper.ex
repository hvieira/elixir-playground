defmodule DummyProductApiWeb.MocksHelper do

  import ExUnit.Callbacks

  def setup_mocks(_context) do
    original_user_store = Application.get_env(:dummy_product_api, :user_store, DummyProductApi.UserStoreMock)
    Application.put_env(:dummy_product_api, :user_store, DummyProductApi.UserStoreMock)
    on_exit(fn -> Application.put_env(:dummy_product_api, :user_store,original_user_store) end)
  end

end
