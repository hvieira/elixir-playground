defmodule CalculatorWebWeb.CalculatorLive do
  use CalculatorWebWeb, :live_view

#  def render(assigns) do
#  Phoenix.View.render(CalculatorWebWeb.PageView, "calculator.html", assigns)
#  end

  def mount(_params, _session, socket) do
    updated_socket = socket
    |> assign(:expression, "")
    |> assign(:result, "")
    {:ok, updated_socket}
  end

  def handle_event("add_char", values, socket) do
    {:noreply, assign(socket, :expression, socket.assigns.expression <> values["char"])}
  end

  def handle_event("clean", _values, socket) do
    {:noreply, assign(socket, :expression, "")}
  end

  def handle_event("calculate", _values, socket) do
    {:ok, result} = Calculator.Core.calculate(socket.assigns.expression)
    {:noreply, assign(socket, :result, result)}
  end
end