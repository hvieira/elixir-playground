defmodule CalculatorWebWeb.PageController do
  use CalculatorWebWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
