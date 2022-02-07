defmodule Calculator.Core.Interpreter do
  @type operator() :: :add | :subtract | :multiply | :divide
  @type interpreted_computation() :: %{n1: integer(), operator: operator(), n2: integer()}

  # TODO module doc test
  @spec interpret(String.t()) :: {:ok, interpreted_computation()} | {:invalid_input, String.t()}
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
end
