defmodule DummyProductApiWeb.ErrorController do
  use DummyProductApiWeb, :controller

  def call(conn, {:error, :bad_request}) do
    conn
    |> put_status(:bad_request)
    |> put_view(DummyProductApiWeb.ErrorView)
    |> render("400.json")
  end

  def call(conn, {:error, :internal_server_error}) do
    conn
    |> put_status(:internal_server_error)
    |> put_view(DummyProductApiWeb.ErrorView)
    |> render("500.json")
  end
end
