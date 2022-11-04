defmodule DummyProductApi.UserRegistry do
  @moduledoc false

  defp user_store() do
    Application.get_env(:dummy_product_api, :user_store)
  end

  def signup_user(user_attributes) do
    with {:ok, user} <- user_store().create_user(user_attributes) do
      {:ok, user}
    else
      {:error, %Ecto.Changeset{valid?: false}} ->
        {:error, :invalid_user_attributes}

      err ->
        err
    end
  end
end
