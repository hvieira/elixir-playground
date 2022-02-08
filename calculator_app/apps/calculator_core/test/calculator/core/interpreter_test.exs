defmodule CalculatorInterpreterTest do
  use ExUnit.Case, async: true

  alias Calculator.Core.Interpreter
  alias Calculator.Core.Expression

  @default_decimal_factor 1000

  test "interpret add operations" do
    assert Interpreter.interpret("1+2", @default_decimal_factor) ==
             {:ok, %{n1: 1000, operator: :add, n2: 2000}}

    assert Interpreter.interpret("0+2", @default_decimal_factor) ==
             {:ok, %{n1: 0, operator: :add, n2: 2000}}

    assert Interpreter.interpret("1+0", @default_decimal_factor) ==
             {:ok, %{n1: 1000, operator: :add, n2: 0}}

    assert Interpreter.interpret("100+33", @default_decimal_factor) ==
             {:ok, %{n1: 100_000, operator: :add, n2: 33000}}

    assert Interpreter.interpret("100.3+33.7", @default_decimal_factor) ==
             {:ok, %{n1: 100_300, operator: :add, n2: 33700}}
  end

  test "interpret subtract operations" do
    assert Interpreter.interpret("1-2", @default_decimal_factor) ==
             {:ok, %{n1: 1000, operator: :subtract, n2: 2000}}

    assert Interpreter.interpret("0-2", @default_decimal_factor) ==
             {:ok, %{n1: 0, operator: :subtract, n2: 2000}}

    assert Interpreter.interpret("1-0", @default_decimal_factor) ==
             {:ok, %{n1: 1000, operator: :subtract, n2: 0}}

    assert Interpreter.interpret("100-33", @default_decimal_factor) ==
             {:ok, %{n1: 100_000, operator: :subtract, n2: 33000}}

    assert Interpreter.interpret("100.3-33.7", @default_decimal_factor) ==
             {:ok, %{n1: 100_300, operator: :subtract, n2: 33700}}
  end

  test "interpret multiply operations" do
    assert Interpreter.interpret("1*2", @default_decimal_factor) ==
             {:ok, %{n1: 1000, operator: :multiply, n2: 2000}}

    assert Interpreter.interpret("0*2", @default_decimal_factor) ==
             {:ok, %{n1: 0, operator: :multiply, n2: 2000}}

    assert Interpreter.interpret("1*0", @default_decimal_factor) ==
             {:ok, %{n1: 1000, operator: :multiply, n2: 0}}

    assert Interpreter.interpret("100*33", @default_decimal_factor) ==
             {:ok, %{n1: 100_000, operator: :multiply, n2: 33000}}

    assert Interpreter.interpret("100.3*33.7", @default_decimal_factor) ==
             {:ok, %{n1: 100_300, operator: :multiply, n2: 33700}}
  end

  test "interpret divide operations" do
    assert Interpreter.interpret("1/2", @default_decimal_factor) ==
             {:ok, %{n1: 1000, operator: :divide, n2: 2000}}

    assert Interpreter.interpret("0/2", @default_decimal_factor) ==
             {:ok, %{n1: 0, operator: :divide, n2: 2000}}

    assert Interpreter.interpret("1/0", @default_decimal_factor) ==
             {:ok, %{n1: 1000, operator: :divide, n2: 0}}

    assert Interpreter.interpret("100/33", @default_decimal_factor) ==
             {:ok, %{n1: 100_000, operator: :divide, n2: 33000}}

    assert Interpreter.interpret("100.3/33.7", @default_decimal_factor) ==
             {:ok, %{n1: 100_300, operator: :divide, n2: 33700}}
  end

  test "handles empty spaces" do
    assert Interpreter.interpret(" 1/2", @default_decimal_factor) ==
             {:ok, %{n1: 1000, operator: :divide, n2: 2000}}

    assert Interpreter.interpret("1 /2", @default_decimal_factor) ==
             {:ok, %{n1: 1000, operator: :divide, n2: 2000}}

    assert Interpreter.interpret("1/ 2", @default_decimal_factor) ==
             {:ok, %{n1: 1000, operator: :divide, n2: 2000}}

    assert Interpreter.interpret("1/2 ", @default_decimal_factor) ==
             {:ok, %{n1: 1000, operator: :divide, n2: 2000}}

    assert Interpreter.interpret(" 1 / 2 ", @default_decimal_factor) ==
             {:ok, %{n1: 1000, operator: :divide, n2: 2000}}
  end

  test "handles bad input" do
    assert match?({:invalid_input, _}, Interpreter.interpret("", @default_decimal_factor))
    assert match?({:invalid_input, _}, Interpreter.interpret("hack", @default_decimal_factor))
    assert match?({:invalid_input, _}, Interpreter.interpret("l33t", @default_decimal_factor))
    assert match?({:invalid_input, _}, Interpreter.interpret("l3+3t", @default_decimal_factor))
    assert match?({:invalid_input, _}, Interpreter.interpret("l33t/2", @default_decimal_factor))
    assert match?({:invalid_input, _}, Interpreter.interpret("1/2l33t", @default_decimal_factor))

    assert match?(
             {:invalid_input, _},
             Interpreter.interpret("1 + some random text", @default_decimal_factor)
           )

    assert match?({:invalid_input, _}, Interpreter.interpret("1 # 2", @default_decimal_factor))
    assert match?({:invalid_input, _}, Interpreter.interpret("1 \\ 2", @default_decimal_factor))
    assert match?({:invalid_input, _}, Interpreter.interpret("1 2", @default_decimal_factor))
  end

  test "enforces usage of leading left zero before decimals" do
    assert {:invalid_input, "Could not interpret number .005"} ==
             Interpreter.interpret(".005+.33", @default_decimal_factor)
  end

  test "can interpret simple calculation - add expressions" do
    assert Interpreter.interpret_expression("3+7") ==
             %Expression{
               left: 3,
               operator: :add,
               right: 7
             }

    assert Interpreter.interpret_expression("3.3+7.7") ==
             %Expression{
               left: 3.3,
               operator: :add,
               right: 7.7
             }
  end

  test "can interpret simple calculation - subtract expressions" do
    assert Interpreter.interpret_expression("3-7") ==
             %Expression{
               left: 3,
               operator: :subtract,
               right: 7
             }

    assert Interpreter.interpret_expression("3.3-7.7") ==
             %Expression{
               left: 3.3,
               operator: :subtract,
               right: 7.7
             }
  end

  test "can interpret simple calculation - multiply expressions" do
    assert Interpreter.interpret_expression("3*7") ==
             %Expression{
               left: 3,
               operator: :multiply,
               right: 7
             }

    assert Interpreter.interpret_expression("3.3*7.7") ==
             %Expression{
               left: 3.3,
               operator: :multiply,
               right: 7.7
             }
  end

  test "can interpret simple calculation - divide expressions" do
    assert Interpreter.interpret_expression("3/7") ==
             %Expression{
               left: 3,
               operator: :divide,
               right: 7
             }

    assert Interpreter.interpret_expression("3.3/7.7") ==
             %Expression{
               left: 3.3,
               operator: :divide,
               right: 7.7
             }
  end

  test "can interpret subsequent signs" do
    assert Interpreter.interpret_expression("3.3++3.7") ==
             %Expression{
               left: 3.3,
               operator: :add,
               right: %Expression{left: 0, operator: :add, right: 3.7, within_parens: true}
             }

    assert Interpreter.interpret_expression("3.3+-3.7") ==
             %Expression{
               left: 3.3,
               operator: :add,
               right: %Expression{left: 0, operator: :subtract, right: 3.7, within_parens: true}
             }

    assert Interpreter.interpret_expression("3.3--3.7") ==
             %Expression{
               left: 3.3,
               operator: :subtract,
               right: %Expression{left: 0, operator: :subtract, right: 3.7, within_parens: true}
             }

    assert Interpreter.interpret_expression("3.3-+3.7") ==
             %Expression{
               left: 3.3,
               operator: :subtract,
               right: %Expression{left: 0, operator: :add, right: 3.7, within_parens: true}
             }

    assert Interpreter.interpret_expression("3*+7") ==
             %Expression{
               left: 3,
               operator: :multiply,
               right: %Expression{left: 0, operator: :add, right: 7, within_parens: true}
             }

    assert Interpreter.interpret_expression("3*-7") ==
             %Expression{
               left: 3,
               operator: :multiply,
               right: %Expression{left: 0, operator: :subtract, right: 7, within_parens: true}
             }

    assert Interpreter.interpret_expression("3/+7") ==
             %Expression{
               left: 3,
               operator: :divide,
               right: %Expression{left: 0, operator: :add, right: 7, within_parens: true}
             }

    assert Interpreter.interpret_expression("3/-7") ==
             %Expression{
               left: 3,
               operator: :divide,
               right: %Expression{left: 0, operator: :subtract, right: 7, within_parens: true}
             }
  end

  test "can interpret subsequent signs - a bunch of them" do
    assert Interpreter.interpret_expression("3.3+--+3.7") ==
             %Expression{
               left: 3.3,
               operator: :add,
               right: %Expression{
                 within_parens: true,
                 left: 0,
                 operator: :subtract,
                 right: %Expression{
                   within_parens: true,
                   left: 0,
                   operator: :subtract,
                   right: %Expression{
                     within_parens: true,
                     left: 0,
                     operator: :add,
                     right: 3.7
                   }
                 }
               }
             }
  end

  test "raises when subsequent signs are invalid" do
    assert_raise ArgumentError, "Malformed expression", fn ->
      Interpreter.interpret_expression("1//1")
    end

    assert_raise ArgumentError, "Malformed expression", fn ->
      Interpreter.interpret_expression("1**1")
    end
  end
end
