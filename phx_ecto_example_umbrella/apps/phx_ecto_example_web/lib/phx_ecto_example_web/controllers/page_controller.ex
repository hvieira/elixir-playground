defmodule PhxEctoExampleWeb.PageController do
  use PhxEctoExampleWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
