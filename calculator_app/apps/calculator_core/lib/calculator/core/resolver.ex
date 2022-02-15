defmodule Calculator.Core.Resolver do
  alias Calculator.Core.Expression

  def resolve(expr) do
    expr
    |> resolve_expression
  end

  defp resolve_expression(n) when is_number(n),
    do: n

  ### add ###
  defp resolve_expression(%Expression{left: l, operator: :add, right: r})
       when is_number(l) and is_number(r),
       do: l + r

  defp resolve_expression(%Expression{left: l, operator: :add, right: r})
       when is_number(l),
       do: l + resolve_expression(r)

  defp resolve_expression(%Expression{left: l, operator: :add, right: r})
       when is_number(r),
       do: resolve_expression(l) + r

  defp resolve_expression(%Expression{left: l, operator: :add, right: r}),
    do: resolve_expression(l) + resolve_expression(r)

  ### subtract ###
  defp resolve_expression(%Expression{left: l, operator: :subtract, right: r})
       when is_number(l) and is_number(r),
       do: l - r

  defp resolve_expression(%Expression{left: l, operator: :subtract, right: r})
       when is_number(l),
       do: l - resolve_expression(r)

  defp resolve_expression(%Expression{left: l, operator: :subtract, right: r})
       when is_number(r),
       do: resolve_expression(l) - r

  defp resolve_expression(%Expression{left: l, operator: :subtract, right: r}),
    do: resolve_expression(l) - resolve_expression(r)

  ### multiply ###
  defp resolve_expression(%Expression{left: l, operator: :multiply, right: r})
       when is_number(l) and is_number(r),
       do: l * r

  defp resolve_expression(%Expression{left: l, operator: :multiply, right: r})
       when is_number(l),
       do: l * resolve_expression(r)

  defp resolve_expression(%Expression{left: l, operator: :multiply, right: r})
       when is_number(r),
       do: resolve_expression(l) * r

  defp resolve_expression(%Expression{left: l, operator: :multiply, right: r}),
    do: resolve_expression(l) * resolve_expression(r)

  ### divide ###
  defp resolve_expression(%Expression{left: l, operator: :divide, right: r})
       when is_number(l) and is_number(r),
       do: l / r

  defp resolve_expression(%Expression{left: l, operator: :divide, right: r})
       when is_number(l),
       do: l / resolve_expression(r)

  defp resolve_expression(%Expression{left: l, operator: :divide, right: r})
       when is_number(r),
       do: resolve_expression(l) / r

  defp resolve_expression(%Expression{left: l, operator: :divide, right: r}),
    do: resolve_expression(l) / resolve_expression(r)
end
