defmodule CalculatorWebWeb.PageController do
  use CalculatorWebWeb, :controller

  def index(conn, _params) do
    IO.inspect(Calculator.Core.add(1,2))
    render(conn, "index.html")
  end
end
