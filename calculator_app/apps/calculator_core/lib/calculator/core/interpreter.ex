defmodule Calculator.Core.Interpreter do
  alias Calculator.Core.Expression

  def interpret("") do
    {:invalid_input, "No expression given"}
  end

  def interpret(str) do
    try do
      str
      |> interpret_expression(nil)
      |> Expression.validate!()
    rescue
      e in ArgumentError -> {:invalid_input, e.message}
    end
  end

  defp interpret_expression(<<char, _::binary>> = str, nil)
       when char in ?0..?9 do
    {float, remainder_str} = Float.parse(str)
    interpret_expression(remainder_str, float)
  end

  defp interpret_expression(<<char, remainder_str::binary>>, nil)
       when char in [?+, ?-, ?*, ?/] do
    operator = operator_from_char(char)

    expr =
      %Expression{}
      |> Expression.add_operator(operator)

    interpret_expression(remainder_str, expr)
  end

  defp interpret_expression(<<char, remainder_str::binary>>, n)
       when char in [?+, ?-, ?*, ?/] and is_number(n) do
    operator = operator_from_char(char)

    expr =
      %Expression{}
      |> Expression.add_value(n)
      |> Expression.add_operator(operator)

    interpret_expression(remainder_str, expr)
  end

  defp interpret_expression(<<char, remainder_str::binary>>, %Expression{} = expr)
       when char in [?+, ?-, ?*, ?/] do
    operator = operator_from_char(char)

    interpret_expression(remainder_str, Expression.add_operator(expr, operator))
  end

  defp interpret_expression(<<char, _::binary>> = str, %Expression{} = expr)
       when char in ?0..?9 do
    {float, remainder_str} = Float.parse(str)
    interpret_expression(remainder_str, Expression.add_value(expr, float))
  end

  defp interpret_expression(<<?(, rest::binary>>, expr) do
    {enclosed_expr, remainder} = capture_enclosed_expression(rest)

    interpret_expression(
      remainder,
      Expression.add_parentheses_encapsulated_expression(expr, enclosed_expr)
    )
  end

  defp interpret_expression(<<?), _::binary>>, _expr),
    do: raise(ArgumentError, "Malformed expression. Parentheses are unbalanced")

  defp interpret_expression("", built_expr) when is_number(built_expr), do: built_expr
  defp interpret_expression("", built_expr), do: Expression.validate!(built_expr)

  defp interpret_expression(str, _expr),
    do: raise(ArgumentError, "Cannot interpret expression #{str}")

  # utilities
  defp capture_enclosed_expression(str, captured \\ [], level \\ 0)

  defp capture_enclosed_expression(<<?), rest::binary>>, captured, 0),
    do: {
      interpret_expression(List.to_string(captured), nil),
      rest
    }

  defp capture_enclosed_expression(<<?), rest::binary>>, captured, level),
    do: capture_enclosed_expression(rest, captured ++ [?)], level - 1)

  defp capture_enclosed_expression(<<?(, rest::binary>>, captured, level),
    do: capture_enclosed_expression(rest, captured ++ [?(], level + 1)

  defp capture_enclosed_expression(<<char, rest::binary>>, captured, level),
    do: capture_enclosed_expression(rest, captured ++ [char], level)

  defp capture_enclosed_expression("", _captured, _level),
    do: raise(ArgumentError, "Malformed expression. Parentheses are unbalanced")

  defp operator_from_char(?+), do: :add
  defp operator_from_char(?-), do: :subtract
  defp operator_from_char(?*), do: :multiply
  defp operator_from_char(?/), do: :divide
end
