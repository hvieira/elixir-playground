defmodule Calculator.Core.Expression do
  @enforce_keys [:left, :operator, :right]
  defstruct [:left, :operator, :right]

  @type t(left, operator, right) :: %Calculator.Core.Expression{
          left: left,
          operator: operator,
          right: right
        }

  @type t :: %Calculator.Core.Expression{
          left: Calculator.Core.Expression.t(),
          operator: operator(),
          right: Calculator.Core.Expression.t()
        }

  @type operator() :: :add | :subtract | :multiply | :divide
end
