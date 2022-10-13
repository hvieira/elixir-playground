defmodule DummyProductApiWeb.UserView do
  use DummyProductApiWeb, :view

  def render("create.json", %{user: user}) do
    %{
      data: %{
        id: user.id,
        name: user.name
      }
    }
  end
end
