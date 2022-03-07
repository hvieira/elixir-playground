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

  # TODO (minor) probably it might make sense to move the agents under the resolver namespace and move these functions to the resolver itself
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

  @spec calculate(String.t()) :: {:ok, String.t()} | {:invalid_input, String.t()}
  def calculate(calculation_str) do
    alias Calculator.Core.Interpreter
    alias Calculator.Core.Resolver

    result =
      Interpreter.interpret(calculation_str)
      |> Resolver.resolve()

    {:ok, Float.round(result, 5)}
  end
end
