ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(DummyProductApi.Repo, :manual)

Mox.defmock(DummyProductApi.UserStoreMock, for: DummyProductApi.UserStore)
Application.put_env(:dummy_product_api, :user_store, DummyProductApi.UserStoreMock)
