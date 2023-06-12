defmodule DummyProductApi.ProductRegistry do
  @moduledoc false

  alias DummyProductApi.Product

  defp product_store() do
    Application.get_env(:dummy_product_api, :product_store)
  end

  def get_product_by_id(product_id), do: product_store().get(product_id)

  def create_product(user, product_attributes) do
    new_product =
      user
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

  def update_product(user, product_id, product_attributes) do
    with product when not is_nil(product) <- product_store().get(product_id),
         :user_is_owner <- is_user_owner_of_product(user, product) do
      product
      |> Product.changeset(product_attributes)
      |> product_store().update_product()
    else
      :user_not_owner ->
        {:error, :user_not_owner}
      nil ->
        {:error, :product_not_found}
    end
  end

  defp is_user_owner_of_product(user, product) do
    if product.owner_user_id == user.id do
      :user_is_owner
    else
      :user_not_owner
    end
  end
end
