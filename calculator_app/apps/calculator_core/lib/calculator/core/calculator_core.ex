defmodule Calculator.Core do
  use Application

  def start(_type, _args) do
    ## TODO: in truth this is not needed. We will have 4 agents per "operation" (+,-,*,/). Clients will use the API from this
    children = [
      {Calculator.Core.SumAgent, name: Calculator.Core.SumAgent},
      {Calculator.Core.MinusAgent, name: Calculator.Core.MinusAgent}
    ]

    opts = [strategy: :one_for_one, name: Calculator.Core.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def sum(n1, n2) do
    GenServer.call(Calculator.Core.SumAgent, {:sum, n1, n2})
  end

  def minus(n1, n2) do
    GenServer.call(Calculator.Core.MinusAgent, {:minus, n1, n2})
  end
end
