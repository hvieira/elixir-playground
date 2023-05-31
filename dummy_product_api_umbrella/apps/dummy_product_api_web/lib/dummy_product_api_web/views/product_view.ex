defmodule DummyProductApiWeb.ProductView do
  use DummyProductApiWeb, :view

  def render("create.json", %{product: product}) do
    %{
      data: %{
        id: product.id,
        name: product.name,
        description: product.description,
        value: product.value
      }
    }
  end
end
