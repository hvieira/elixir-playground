defmodule Calculator.Core do
  use Application

  @decimal_factor 1000

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

  @spec calculate(String.t()) :: {:ok, String.t()} | {:invalid_input, String.t()}
  def calculate(calculation_str) do
    alias Calculator.Core.Interpreter
    with {:ok, %{n1: number1, operator: operator, n2: number2}} <- Interpreter.interpret(calculation_str, @decimal_factor)
    do
      # TODO At this point we can probably just call the function in this module given by the atom in the operation
      # https://stackoverflow.com/a/36679477
      
      # TODO looking at the decimal factor usage, it might be an indication that it might need to be refactored
      int_value = case operator do
        :add -> add(number1, number2)
        :subtract -> subtract(number1, number2)
        :multiply -> multiply(number1, number2 / @decimal_factor)
        :divide -> divide(number1, number2 / @decimal_factor)
      end

      # TODO define a maximum of decimal places in the result - e.g 5
      {:ok, "#{int_value / @decimal_factor}"}
    end

  end
end
