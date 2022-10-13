defmodule DummyProductApiWeb.ErrorController do
  use DummyProductApiWeb, :controller

  def call(conn, {:error, :bad_request}) do
    conn
    |> put_status(:bad_request)
    |> put_view(DummyProductApiWeb.ErrorView)
    |> render("400.json")
  end
end
