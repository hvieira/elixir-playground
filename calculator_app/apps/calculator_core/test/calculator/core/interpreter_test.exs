defmodule CalculatorInterpreterTest do
  use ExUnit.Case, async: true

  alias Calculator.Core.Interpreter

  test "Empty string returns an error" do
    assert Interpreter.interpret("") == {:invalid_input, "Empty string given"}
  end

  test "interpret add operations" do
    assert Interpreter.interpret("1+2") == {:ok, %{n1: "1", operator: :add, n2: "2"}}
    assert Interpreter.interpret("0+2") == {:ok, %{n1: "0", operator: :add, n2: "2"}}
    assert Interpreter.interpret("1+0") == {:ok, %{n1: "1", operator: :add, n2: "0"}}
    assert Interpreter.interpret("100+33") == {:ok, %{n1: "100", operator: :add, n2: "33"}}

    assert Interpreter.interpret("100.3+33.7") ==
             {:ok, %{n1: "100.3", operator: :add, n2: "33.7"}}
  end

  test "interpret subtract operations" do
    assert Interpreter.interpret("1-2") == {:ok, %{n1: "1", operator: :subtract, n2: "2"}}
    assert Interpreter.interpret("0-2") == {:ok, %{n1: "0", operator: :subtract, n2: "2"}}
    assert Interpreter.interpret("1-0") == {:ok, %{n1: "1", operator: :subtract, n2: "0"}}
    assert Interpreter.interpret("100-33") == {:ok, %{n1: "100", operator: :subtract, n2: "33"}}

    assert Interpreter.interpret("100.3-33.7") ==
             {:ok, %{n1: "100.3", operator: :subtract, n2: "33.7"}}
  end

  test "interpret multiply operations" do
    assert Interpreter.interpret("1*2") == {:ok, %{n1: "1", operator: :multiply, n2: "2"}}
    assert Interpreter.interpret("0*2") == {:ok, %{n1: "0", operator: :multiply, n2: "2"}}
    assert Interpreter.interpret("1*0") == {:ok, %{n1: "1", operator: :multiply, n2: "0"}}
    assert Interpreter.interpret("100*33") == {:ok, %{n1: "100", operator: :multiply, n2: "33"}}

    assert Interpreter.interpret("100.3*33.7") ==
             {:ok, %{n1: "100.3", operator: :multiply, n2: "33.7"}}
  end

  test "interpret divide operations" do
    assert Interpreter.interpret("1/2") == {:ok, %{n1: "1", operator: :divide, n2: "2"}}
    assert Interpreter.interpret("0/2") == {:ok, %{n1: "0", operator: :divide, n2: "2"}}
    assert Interpreter.interpret("1/0") == {:ok, %{n1: "1", operator: :divide, n2: "0"}}
    assert Interpreter.interpret("100/33") == {:ok, %{n1: "100", operator: :divide, n2: "33"}}

    assert Interpreter.interpret("100.3/33.7") ==
             {:ok, %{n1: "100.3", operator: :divide, n2: "33.7"}}
  end
end
