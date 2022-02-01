defmodule Calculator.Core do
  use Application

  def start(_type, _args) do
    children = [
      {Calculator.Core.AddAgent, name: Calculator.Core.AddAgent},
      {Calculator.Core.SubtractAgent, name: Calculator.Core.SubtractAgent},
      {Calculator.Core.MultiplyAgent, name: Calculator.Core.MultiplyAgent},
      {Calculator.Core.DivideAgent, name: Calculator.Core.DivideAgent}
    ]

    opts = [strategy: :one_for_one, name: Calculator.Core.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def add(n1, n2) do
    GenServer.call(Calculator.Core.AddAgent, {:add, n1, n2})
  end

  def subtract(n1, n2) do
    GenServer.call(Calculator.Core.SubtractAgent, {:subtract, n1, n2})
  end

  def multiply(n1, n2) do
    GenServer.call(Calculator.Core.MultiplyAgent, {:multiply, n1, n2})
  end

  def divide(n1, n2) do
    GenServer.call(Calculator.Core.DivideAgent, {:divide, n1, n2})
  end
end
