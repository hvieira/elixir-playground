defmodule Calculator.Core.Interpreter do
  @type operator() :: :add | :subtract | :multiply | :divide
  @type interpreted_computation() :: %{n1: number(), operator: operator(), n2: number()}

  # TODO module doc test
  @spec interpret(String.t()) :: {:ok, interpreted_computation()} | {:invalid_input, String.t()}
  def interpret("") do
    {:invalid_input, "Empty string given"}
  end

  def interpret(str) do
    str
    |> clean_input
    |> interpret_clean
  end

  @calculation_regex ~r/(?<n1>[0-9.]+)(?<operator>\+|-|\*|\/)(?<n2>[0-9.]+)/
  defp interpret_clean(str) do
    case Regex.named_captures(@calculation_regex, str) do
      nil ->
        {:invalid_input, "Could not interpret input"}

      %{"n1" => number1, "n2" => number2, "operator" => "+"} ->
        {:ok, %{n1: number1, operator: :add, n2: number2}}

      %{"n1" => number1, "n2" => number2, "operator" => "-"} ->
        {:ok, %{n1: number1, operator: :subtract, n2: number2}}

      %{"n1" => number1, "n2" => number2, "operator" => "*"} ->
        {:ok, %{n1: number1, operator: :multiply, n2: number2}}

      %{"n1" => number1, "n2" => number2, "operator" => "/"} ->
        {:ok, %{n1: number1, operator: :divide, n2: number2}}
    end
  end

  defp clean_input(str) do
    String.replace(str, " ", "", global: true)
  end
end
