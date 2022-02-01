defmodule Calculator.Core do
  use Application

  def start(_type, _args) do
    ## TODO: in truth this is not needed. We will have 4 agents per "operation" (+,-,*,/). Clients will use the API from this
    children = [
      {Calculator.Core.AddAgent, name: Calculator.Core.AddAgent},
      {Calculator.Core.SubtractAgent, name: Calculator.Core.SubtractAgent},
      {Calculator.Core.MultiplyAgent, name: Calculator.Core.MultiplyAgent}
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
end
