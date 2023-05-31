defmodule DummyProductApi.ProductRegistry do
  @moduledoc false

  alias DummyProductApi.Product

  defp product_store() do
    Application.get_env(:dummy_product_api, :product_store)
  end

  def create_product(user, product_attributes) do

    new_product = user
    |> Ecto.build_assoc(:products)
    |> Product.changeset(product_attributes)

    with {:ok, created_product} <- product_store().create_product(new_product) do
      {:ok, created_product}
    else
      {:error, %Ecto.Changeset{valid?: false}} ->
        {:error, :invalid_product_attributes}

      err ->
        err
    end
  end
end
