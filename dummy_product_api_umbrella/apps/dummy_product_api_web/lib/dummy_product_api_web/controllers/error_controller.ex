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

  def call(conn, {:error, :forbidden}) do
    conn
    |> put_status(:forbidden)
    |> put_view(DummyProductApiWeb.ErrorView)
    |> render("403.json")
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(DummyProductApiWeb.ErrorView)
    |> render("404.json")
  end
end
