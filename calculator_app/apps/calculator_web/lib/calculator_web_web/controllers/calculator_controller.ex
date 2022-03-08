defmodule CalculatorWebWeb.CalculatorController do
  use CalculatorWebWeb, :controller

  def js_calculator(conn, _params) do
    conn
    |> put_root_layout("calculator.html")
    |> render("js_calculator.html")
  end
end
