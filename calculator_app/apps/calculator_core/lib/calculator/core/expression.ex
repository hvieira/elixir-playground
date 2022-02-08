defmodule Calculator.Core.Expression do
  @enforce_keys [:left, :operator, :right]
  defstruct [:left, :operator, :right, within_parens: false]

  @type t(left, operator, right, within_parens) :: %Calculator.Core.Expression{
          left: left,
          operator: operator,
          right: right,
          within_parens: within_parens
        }

  @type t :: %Calculator.Core.Expression{
          left: Calculator.Core.Expression.t(),
          operator: operator(),
          right: Calculator.Core.Expression.t(),
          within_parens: true | false
        }

  @type operator() :: :add | :subtract | :multiply | :divide
end
