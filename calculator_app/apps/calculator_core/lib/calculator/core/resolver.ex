defmodule Calculator.Core.Resolver do
  alias Calculator.Core.Expression

  def resolve(expr) do
    expr
    |> resolve_expression
  end

  defp resolve_expression(n) when is_number(n),
    do: n

  defp resolve_expression(%Expression{left: l, operator: op, right: r}) do
    apply(Calculator.Core, op, [resolve_expression(l), resolve_expression(r)])
  end
end
