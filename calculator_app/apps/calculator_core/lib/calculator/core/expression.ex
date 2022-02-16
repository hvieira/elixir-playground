defmodule Calculator.Core.Expression do
  alias Calculator.Core.Expression

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

  @spec add_value(Expression.t() | number(), number()) :: Expression.t()
  def add_value(expr, n)
  def add_value(%Expression{left: nil}, n), do: %Expression{left: n}

  def add_value(%Expression{operator: nil, right: nil}, _n),
    do: raise(ArgumentError, "Malformed expression")

  def add_value(%Expression{right: nil} = expr, n), do: %{expr | right: n}

  # special case to allow adding values to most priority operations. See match above
  def add_value(expr, n) when expr.right.right == nil do
    %{expr | right: %{expr.right | right: n}}
  end

  @spec add_operator(Expression.t(), operator()) :: Expression.t()
  def add_operator(%Expression{left: nil}, :multiply),
    do: raise(ArgumentError, "Malformed expression")

  def add_operator(%Expression{left: nil}, :divide),
    do: raise(ArgumentError, "Malformed expression")

  def add_operator(%Expression{operator: nil} = expr, op), do: %{expr | operator: op}

  # defines priority of multiply and divide over add and subtract
  def add_operator(%Expression{left: l, operator: existing_op, right: r}, op)
      when existing_op in [:add, :subtract] and op in [:multiply, :divide],
      do: %Expression{
        left: l,
        operator: existing_op,
        right: %Expression{
          left: r,
          operator: op,
          right: nil
        }
      }

  def add_operator(%Expression{operator: _op} = expr, op),
    do: %Expression{left: expr, operator: op}

  def add_parentheses_encapsulated_expression(
        %Expression{right: nil} = target_expr,
        encapsulated_expression
      ),
      do: %{target_expr | right: validate!(encapsulated_expression)}

  # TODO ArgumentError here is not ideal because it is a validation error
  def validate!(%Expression{right: nil}), do: raise(ArgumentError, "Malformed expression")
  def validate!(%Expression{operator: nil}), do: raise(ArgumentError, "Malformed expression")
  def validate!(expr), do: expr
end
