defmodule DummyProductApiWeb.PageController do
  use DummyProductApiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
