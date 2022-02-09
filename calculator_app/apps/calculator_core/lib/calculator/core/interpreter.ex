defmodule Calculator.Core.Interpreter do
  alias Calculator.Core.Expression

  def interpret("") do
    {:invalid_input, "Empty string given"}
  end

  def interpret(str, decimal_factor \\ 1000) do
    with cleaned <- clean_input(str),
         {:ok, validated} <- validate(cleaned) do
      try do
        interpret_clean(validated, decimal_factor)
      rescue
        e in ArgumentError -> {:invalid_input, e.message}
      end
    end
  end

  defp validate(str) do
    case Regex.match?(~r/^[0-9.\+|\-|\*|\/]+$/, str) do
      true -> {:ok, str}
      false -> {:invalid_input, "Provided string is not a valid calculation"}
    end
  end

  @calculation_regex ~r/(?<n1>[0-9.]+)(?<operator>\+|-|\*|\/)(?<n2>[0-9.]+)/
  defp interpret_clean(str, decimal_factor) do
    case Regex.named_captures(@calculation_regex, str) do
      nil ->
        {:invalid_input, "Could not interpret input"}

      %{"n1" => number1, "n2" => number2, "operator" => "+"} ->
        {:ok,
         %{
           n1: string_number_to_integer(number1, decimal_factor),
           operator: :add,
           n2: string_number_to_integer(number2, decimal_factor)
         }}

      %{"n1" => number1, "n2" => number2, "operator" => "-"} ->
        {:ok,
         %{
           n1: string_number_to_integer(number1, decimal_factor),
           operator: :subtract,
           n2: string_number_to_integer(number2, decimal_factor)
         }}

      %{"n1" => number1, "n2" => number2, "operator" => "*"} ->
        {:ok,
         %{
           n1: string_number_to_integer(number1, decimal_factor),
           operator: :multiply,
           n2: string_number_to_integer(number2, decimal_factor)
         }}

      %{"n1" => number1, "n2" => number2, "operator" => "/"} ->
        {:ok,
         %{
           n1: string_number_to_integer(number1, decimal_factor),
           operator: :divide,
           n2: string_number_to_integer(number2, decimal_factor)
         }}

      _ ->
        {:invalid_input, "Could not interpret input"}
    end
  end

  defp clean_input(str) do
    String.replace(str, " ", "", global: true)
  end

  defp string_number_to_integer(number_str, decimal_factor) do
    with {num, _remainder} <- Float.parse(number_str) do
      trunc(num * decimal_factor)
    else
      _ -> raise ArgumentError, message: "Could not interpret number #{number_str}"
    end
  end

  @spec interpret_expression(String.t()) :: {:ok, Expression.t()} | {:invalid_input, String.t()}
  def interpret_expression(str) do
    str
    |> clean_input
    |> interpret_expression(%Expression{left: nil, operator: nil, right: nil})
  end

  # capture number for left
  defp interpret_expression(<<char, _::binary>> = str, %Expression{left: nil} = expr)
       when char in ?0..?9 do
    {float, remainder_str} = Float.parse(str)

    interpret_expression(remainder_str, %{expr | left: float})
  end

  # capture number for right
  defp interpret_expression(
         <<char, _::binary>> = str,
         %Expression{left: left, operator: operator, right: nil} = expr
       )
       when char in ?0..?9 and left != nil and operator != nil do
    {float, remainder_str} = Float.parse(str)

    interpret_expression(remainder_str, %{expr | right: float})
  end

  # when we're looking at a operator and the expression does not have a left term yet - treat it as a sign (for signed numbers)
  defp interpret_expression(
         <<?+, rest::binary>>,
         %Expression{left: nil, operator: nil, right: nil} = expr
       ) do
    interpret_expression(rest, %{expr | left: 0, operator: :add})
  end

  defp interpret_expression(
         <<?-, rest::binary>>,
         %Expression{left: nil, operator: nil, right: nil} = expr
       ) do
    interpret_expression(rest, %{expr | left: 0, operator: :subtract})
  end

  defp interpret_expression(
         <<?*, _rest::binary>>,
         %Expression{left: nil, operator: nil, right: nil}
       ) do
    raise ArgumentError, "Malformed expression"
  end

  defp interpret_expression(
         <<?/, _rest::binary>>,
         %Expression{left: nil, operator: nil, right: nil}
       ) do
    raise ArgumentError, "Malformed expression"
  end

  # when we're looking at a operator and the expression already has a left term and operator but no right term
  defp interpret_expression(
         <<char, _::binary>> = str,
         %Expression{left: left, operator: operator, right: nil} = expr
       )
       when (char == ?+ or char == ?- or char == ?* or char == ?/) and
              operator != nil and left != nil do
    %{
      expr
      | right:
          interpret_expression(
            str,
            %Expression{left: nil, operator: nil, right: nil, within_parens: true}
          )
    }
  end

  # when we're looking at a operator and the expression is already complete
  defp interpret_expression(
         <<char, rest::binary>>,
         %Expression{left: left, operator: operator, right: right, within_parens: wp} = expr
       )
       when (char == ?+ or char == ?- or char == ?* or char == ?/) and
              operator != nil and left != nil and right != nil do
    op =
      case char do
        ?+ -> :add
        ?- -> :subtract
        ?* -> :multiply
        ?/ -> :divide
      end

    %Expression{
      left: %{expr | within_parens: false},
      operator: op,
      right: interpret_expression(rest, %Expression{left: nil, operator: nil, right: nil}),
      within_parens: wp
    }
  end

  # capture operators
  defp interpret_expression(<<?+, rest::binary>>, expr),
    do: interpret_expression(rest, %{expr | operator: :add})

  defp interpret_expression(<<?-, rest::binary>>, expr),
    do: interpret_expression(rest, %{expr | operator: :subtract})

  defp interpret_expression(<<?*, rest::binary>>, expr),
    do: interpret_expression(rest, %{expr | operator: :multiply})

  defp interpret_expression(<<?/, rest::binary>>, expr),
    do: interpret_expression(rest, %{expr | operator: :divide})

  # handle starting parentheses
  defp interpret_expression(<<?(, rest::binary>>, %Expression{left: nil} = expr) do
    {enclosed_expression, remainder} = capture_enclosed_expression(rest)

    interpret_expression(remainder, %{
      expr
      | left:
          interpret_expression(enclosed_expression, %Expression{
            left: nil,
            operator: nil,
            right: nil,
            within_parens: true
          })
    })
  end

  defp interpret_expression(<<?(, rest::binary>>, %Expression{right: nil} = expr) do
    {enclosed_expression, remainder} = capture_enclosed_expression(rest)

    interpret_expression(remainder, %{
      expr
      | right:
          interpret_expression(enclosed_expression, %Expression{
            left: nil,
            operator: nil,
            right: nil,
            within_parens: true
          })
    })
  end

  # handle starting closing parentheses
  defp interpret_expression(<<?), _>>, _expr), do: raise(ArgumentError, "Malformed expression")

  # ending states
  defp interpret_expression("", %Expression{left: left, operator: nil, right: nil}), do: left
  defp interpret_expression("", captured_expr), do: captured_expr

  # utilities
  defp capture_enclosed_expression(str, captured \\ [], level \\ 0)

  defp capture_enclosed_expression(<<?), rest::binary>>, captured, 0),
    do: {List.to_string(captured), rest}

  defp capture_enclosed_expression(<<?), rest::binary>>, captured, level),
    do: capture_enclosed_expression(rest, captured ++ [?)], level - 1)

  defp capture_enclosed_expression(<<?(, rest::binary>>, captured, level),
    do: capture_enclosed_expression(rest, captured ++ [?(], level + 1)

  defp capture_enclosed_expression(<<char, rest::binary>>, captured, level),
    do: capture_enclosed_expression(rest, captured ++ [char], level)

  defp capture_enclosed_expression("", _captured, _level),
    do: raise(ArgumentError, "Malformed expression. Parentheses are unbalanced")
end
