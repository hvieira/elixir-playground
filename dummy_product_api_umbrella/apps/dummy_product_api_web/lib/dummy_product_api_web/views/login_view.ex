defmodule DummyProductApiWeb.LoginView do
  use DummyProductApiWeb, :view

  def render("logged_in.json", %{token: token}) do
    %{
      data: %{
        token: token
      }
    }
  end
end
