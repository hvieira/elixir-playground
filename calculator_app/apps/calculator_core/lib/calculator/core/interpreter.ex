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
    |> String.to_charlist()
    |> interpret_expression(%Expression{left: nil, operator: nil, right: nil}, [])
  end

  defp interpret_expression(
         [char | t],
         captured_expr,
         number_char_bag
       )
       when (char >= ?0 and char < ?9) or char == ?. do
    interpret_expression(t, captured_expr, number_char_bag ++ [char])
  end

  # capture a number for left
  defp interpret_expression(
         [char | _t] = str,
         %Expression{left: nil, operator: nil, right: nil} = expr,
         [_ | _] = number_char_bag
       )
       when char == ?+ or char == ?- or char == ?* or char == ?/ do
    {float, _} = Float.parse(List.to_string(number_char_bag))

    interpret_expression(str, %{expr | left: float}, [])
  end

  # capture the operators
  defp interpret_expression([?+ | t], expr, []) do
    interpret_expression(t, %{expr | operator: :add}, [])
  end

  defp interpret_expression([?- | t], expr, []) do
    interpret_expression(t, %{expr | operator: :subtract}, [])
  end

  defp interpret_expression([?* | t], expr, []) do
    interpret_expression(t, %{expr | operator: :multiply}, [])
  end

  defp interpret_expression([?/ | t], expr, []) do
    interpret_expression(t, %{expr | operator: :divide}, [])
  end

  # capture a number for right
  defp interpret_expression(
         [],
         %Expression{left: _left, operator: _op, right: nil} = expr,
         [_ | _] = number_char_bag
       ) do
    {float, _} = Float.parse(List.to_string(number_char_bag))

    interpret_expression([], %{expr | right: float}, [])
  end

  defp interpret_expression([], captured_expr, []) do
    {:ok, captured_expr}
  end
end
