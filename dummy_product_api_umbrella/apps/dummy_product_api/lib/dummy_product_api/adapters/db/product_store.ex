defmodule DummyProductApi.ProductStore do
  @callback create_product(product :: term) :: {:ok, product :: term} | {:error, reason :: term}
end

defmodule DummyProductApi.ProductDatabaseStore do
  @behaviour DummyProductApi.ProductStore

  alias DummyProductApi.Repo
  alias DummyProductApi.Product

  def create_product(product) do
    Repo.insert(product)
  end
end
