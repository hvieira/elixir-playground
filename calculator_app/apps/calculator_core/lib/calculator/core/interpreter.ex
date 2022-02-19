defmodule Calculator.Core.Interpreter do
  alias Calculator.Core.Expression

  def interpret("") do
    {:invalid_input, "No expression given"}
  end

  def interpret(str) do
    with cleaned <- clean_input(str) do
      try do
        interpret_expression(cleaned, nil)
      rescue
        e in ArgumentError -> {:invalid_input, e.message}
      end
    end
  end

  defp clean_input(str) do
    String.replace(str, " ", "", global: true)
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

  #  defp interpret_expression(<<?+, remainder_str::binary>>, nil),
  #    do: interpret_expression(remainder_str, %Expression{left: 0, operator: :add, right: nil})
  #
  #  defp interpret_expression(<<?+, remainder_str::binary>>, n) when is_number(n),
  #    do: interpret_expression(remainder_str, %Expression{left: n, operator: :add, right: nil})

  #  defp interpret_expression(<<?+, remainder_str::binary>>, expr),
  #    do:
  #      interpret_expression(
  #        remainder_str,
  #        %{expr | left: expr, operator: :add, right: nil}
  #      )

  #  defp interpret_expression(<<?-, remainder_str::binary>>, nil),
  #    do: interpret_expression(remainder_str, %Expression{left: 0, operator: :subtract, right: nil})
  #
  #  defp interpret_expression(<<?-, remainder_str::binary>>, n) when is_number(n),
  #    do: interpret_expression(remainder_str, %Expression{left: n, operator: :subtract, right: nil})

  #  defp interpret_expression(<<?-, remainder_str::binary>>, expr),
  #    do:
  #      interpret_expression(
  #        remainder_str,
  #        %{expr | left: expr, operator: :subtract, right: nil}
  #      )

  #  defp interpret_expression(<<char, _::binary>>, nil)
  #       when char == ?* or char == ?/,
  #       do: raise(ArgumentError, "Malformed expression")
  #
  #  defp interpret_expression(<<?*, remainder_str::binary>>, n) when is_number(n),
  #    do: interpret_expression(remainder_str, %Expression{left: n, operator: :multiply, right: nil})
  #
  #  defp interpret_expression(<<?/, remainder_str::binary>>, n) when is_number(n),
  #    do: interpret_expression(remainder_str, %Expression{left: n, operator: :divide, right: nil})
  #
  #  defp interpret_expression(<<?/, remainder_str::binary>>, expr),
  #    do:
  #      interpret_expression(
  #        remainder_str,
  #        %{expr | left: expr, operator: :divide, right: nil}
  #      )
  #
  #  defp interpret_expression(<<char, _::binary>> = str, %Expression{right: nil} = expr)
  #       when char in ?0..?9 do
  #    {float, remainder_str} = Float.parse(str)
  #    interpret_expression(remainder_str, %{expr | right: float})
  #  end

  # need to define priority of operations
  #  defp interpret_expression(
  #         <<char, remainder_str::binary>>,
  #         %Expression{left: l, operator: op, right: r} = expr
  #       )
  #       when char in [?+, ?-, ?*, ?/] and l != nil and op != nil and r != nil do
  #    operator_found = operator_from_char(char)
  #
  #    case op do
  #      op when op in [:add, :subtract] and operator_found == :multiply ->
  #        # TODO maybe this?
  #        #        {expr, rest} = interpret_expression_until_normal_priority(remainder_str, %Expression{
  #        #          left: r,
  #        #          operator: operator_found,
  #        #          right: nil
  #        #        })
  #
  #        %Expression{
  #          left: l,
  #          operator: op,
  #          right:
  #            interpret_expression(remainder_str, %Expression{
  #              left: r,
  #              operator: operator_found,
  #              right: nil
  #            })
  #        }
  #
  #      op when op in [:multiply] and operator_found in [:add, :subtract] ->
  #        %Expression{
  #          left: l,
  #          operator: op,
  #          right:
  #            interpret_expression(remainder_str, %Expression{
  #              left: r,
  #              operator: operator_found,
  #              right: nil
  #            })
  #        }
  #
  #      _ ->
  #        interpret_expression(
  #          remainder_str,
  #          %{expr | left: expr, operator: operator_found, right: nil}
  #        )
  #    end
  #  end

  #  defp interpret_expression(<<char, remainder_str :: binary>>, expr)
  #    when char in [?+, ?-] do
  #
  #
  #
  #    interpret_expression(
  #      remainder_str,
  #      %{expr | left: expr, operator: operator_from_char(char), right: nil}
  #    )
  #  end

  #  # capture number for left
  #  defp interpret_expression(<<char, _::binary>> = str, %Expression{left: nil} = expr)
  #       when char in ?0..?9 do
  #    {float, remainder_str} = Float.parse(str)
  #
  #    interpret_expression(remainder_str, %{expr | left: float})
  #  end
  #
  #  # capture number for right
  #  defp interpret_expression(
  #         <<char, _::binary>> = str,
  #         %Expression{left: left, operator: operator, right: nil} = expr
  #       )
  #       when char in ?0..?9 and left != nil and operator != nil do
  #    {float, remainder_str} = Float.parse(str)
  #
  #    interpret_expression(remainder_str, %{expr | right: float})
  #  end
  #
  #  # when we're looking at a operator and the expression does not have a left term yet - treat it as a sign (for signed numbers)
  #  defp interpret_expression(
  #         <<?+, rest::binary>>,
  #         %Expression{left: nil, operator: nil, right: nil} = expr
  #       ) do
  #    interpret_expression(rest, %{expr | left: 0, operator: :add})
  #  end
  #
  #  defp interpret_expression(
  #         <<?-, rest::binary>>,
  #         %Expression{left: nil, operator: nil, right: nil} = expr
  #       ) do
  #    interpret_expression(rest, %{expr | left: 0, operator: :subtract})
  #  end
  #
  #  defp interpret_expression(
  #         <<?*, _rest::binary>>,
  #         %Expression{left: nil, operator: nil, right: nil}
  #       ) do
  #    raise ArgumentError, "Malformed expression"
  #  end
  #
  #  defp interpret_expression(
  #         <<?/, _rest::binary>>,
  #         %Expression{left: nil, operator: nil, right: nil}
  #       ) do
  #    raise ArgumentError, "Malformed expression"
  #  end
  #
  #  # when we're looking at a operator and the expression already has a left term and operator but no right term
  #  defp interpret_expression(
  #         <<char, _::binary>> = str,
  #         %Expression{left: left, operator: operator, right: nil} = expr
  #       )
  #       when (char == ?+ or char == ?- or char == ?* or char == ?/) and
  #              left != nil and operator != nil do
  #    %{
  #      expr
  #      | right:
  #          interpret_expression(
  #            str,
  #            %Expression{left: nil, operator: nil, right: nil, within_parens: true}
  #          )
  #    }
  #  end
  #
  #  # when we're looking at a operator and the expression is already complete
  #  defp interpret_expression(
  #         <<char, rest::binary>>,
  #         %Expression{left: left, operator: operator, right: right, within_parens: wp} = expr
  #       )
  #       when (char == ?+ or char == ?- or char == ?* or char == ?/) and
  #              left != nil and operator != nil and right != nil do
  #    op =
  #      case char do
  #        ?+ -> :add
  #        ?- -> :subtract
  #        ?* -> :multiply
  #        ?/ -> :divide
  #      end
  #
  #    %Expression{
  #      left: %{expr | within_parens: false},
  #      operator: op,
  #      right: interpret_expression(rest, %Expression{left: nil, operator: nil, right: nil}),
  #      within_parens: wp
  #    }
  #  end
  #
  #  # capture operators
  #  defp interpret_expression(<<?+, rest::binary>>, expr),
  #    do: interpret_expression(rest, %{expr | operator: :add})
  #
  #  defp interpret_expression(<<?-, rest::binary>>, expr),
  #    do: interpret_expression(rest, %{expr | operator: :subtract})
  #
  #  defp interpret_expression(<<?*, rest::binary>>, expr),
  #    do: interpret_expression(rest, %{expr | operator: :multiply})
  #
  #  defp interpret_expression(<<?/, rest::binary>>, expr),
  #    do: interpret_expression(rest, %{expr | operator: :divide})
  #
  #  # handle starting parentheses
  #  defp interpret_expression(<<?(, rest::binary>>, %Expression{left: nil} = expr) do
  #    {enclosed_expression, remainder} = capture_enclosed_expression(rest)
  #
  #    interpret_expression(remainder, %{
  #      expr
  #      | left:
  #          interpret_expression(enclosed_expression, %Expression{
  #            left: nil,
  #            operator: nil,
  #            right: nil,
  #            within_parens: true
  #          })
  #    })
  #  end
  #
  #  defp interpret_expression(<<?(, rest::binary>>, %Expression{right: nil} = expr) do
  #    {enclosed_expression, remainder} = capture_enclosed_expression(rest)
  #
  #    interpret_expression(remainder, %{
  #      expr
  #      | right:
  #          interpret_expression(enclosed_expression, %Expression{
  #            left: nil,
  #            operator: nil,
  #            right: nil,
  #            within_parens: true
  #          })
  #    })
  #  end
  #
  #  # handle starting closing parentheses
  #  defp interpret_expression(<<?), _>>, _expr), do: raise(ArgumentError, "Malformed expression")
  #
  #  # ending states
  #  defp interpret_expression("", %Expression{left: left, operator: nil, right: nil}), do: left
  #  defp interpret_expression("", %Expression{right: nil}),
  #    do: raise(ArgumentError, "Malformed expression")
  #
  defp interpret_expression("", built_expr) when is_number(built_expr), do: built_expr
  defp interpret_expression("", built_expr), do: Expression.validate!(built_expr)
  #
  #  # utilities
  #  defp capture_enclosed_expression(str, captured \\ [], level \\ 0)
  #
  #  defp capture_enclosed_expression(<<?), rest::binary>>, captured, 0),
  #    do: {List.to_string(captured), rest}
  #
  #  defp capture_enclosed_expression(<<?), rest::binary>>, captured, level),
  #    do: capture_enclosed_expression(rest, captured ++ [?)], level - 1)
  #
  #  defp capture_enclosed_expression(<<?(, rest::binary>>, captured, level),
  #    do: capture_enclosed_expression(rest, captured ++ [?(], level + 1)
  #
  #  defp capture_enclosed_expression(<<char, rest::binary>>, captured, level),
  #    do: capture_enclosed_expression(rest, captured ++ [char], level)
  #
  #  defp capture_enclosed_expression("", _captured, _level),
  #    do: raise(ArgumentError, "Malformed expression. Parentheses are unbalanced")

  defp operator_from_char(?+), do: :add
  defp operator_from_char(?-), do: :subtract
  defp operator_from_char(?*), do: :multiply
  defp operator_from_char(?/), do: :divide
end
