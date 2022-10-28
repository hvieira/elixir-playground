ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(DummyProductApi.Repo, :manual)

ExUnit.configure(exclude: [integration: true])

Mox.defmock(DummyProductApi.UserStoreMock, for: DummyProductApi.UserStore)


