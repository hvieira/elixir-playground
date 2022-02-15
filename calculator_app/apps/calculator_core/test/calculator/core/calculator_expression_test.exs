defmodule CalculatorExpressionTest do
  use ExUnit.Case, async: true

  alias Calculator.Core.Expression

  @default_decimal_factor 1000

  @empty_expression %Expression{}

  test "values added are left when the expression is empty" do
    assert Expression.add_value(@empty_expression, 1) == %Expression{left: 1}
    assert Expression.add_value(@empty_expression, 3) == %Expression{left: 3}
    assert Expression.add_value(@empty_expression, 1083) == %Expression{left: 1083}
    assert Expression.add_value(@empty_expression, 7.3) == %Expression{left: 7.3}
  end

  test "add and subtract operators (signs) added are set if there is not current operator defined" do
    assert Expression.add_operator(@empty_expression, :add) == %Expression{operator: :add}

    assert Expression.add_operator(@empty_expression, :subtract) == %Expression{
             operator: :subtract
           }
  end

  test "values added are right when the expression is has a left value and operator" do
    assert Expression.add_value(%Expression{left: 1, operator: :add}, 2) == %Expression{
             left: 1,
             operator: :add,
             right: 2
           }
  end

  test "adding values when there is a left but no operator raises an argument error" do
    assert_raise ArgumentError, fn ->
      Expression.add_value(%Expression{left: 1, operator: nil}, 2)
    end
  end

  test "starting with multiply operator raises an argument error" do
    assert_raise ArgumentError, fn ->
      Expression.add_operator(@empty_expression, :multiply)
    end
  end

  test "starting with divide operator raises an argument error" do
    assert_raise ArgumentError, fn ->
      Expression.add_operator(@empty_expression, :divide)
    end
  end

  test "build single operand expressions - add" do
    result =
      @empty_expression
      |> Expression.add_value(3)
      |> Expression.add_operator(:add)
      |> Expression.add_value(7)

    assert result == %Expression{left: 3, operator: :add, right: 7}
  end

  test "build single operand expressions - subtract" do
    result =
      @empty_expression
      |> Expression.add_value(3)
      |> Expression.add_operator(:subtract)
      |> Expression.add_value(7)

    assert result == %Expression{left: 3, operator: :subtract, right: 7}
  end

  test "build single operand expressions - multiply" do
    result =
      @empty_expression
      |> Expression.add_value(3)
      |> Expression.add_operator(:multiply)
      |> Expression.add_value(7)

    assert result == %Expression{left: 3, operator: :multiply, right: 7}
  end

  test "build single operand expressions - divide" do
    result =
      @empty_expression
      |> Expression.add_value(3)
      |> Expression.add_operator(:divide)
      |> Expression.add_value(7)

    assert result == %Expression{left: 3, operator: :divide, right: 7}
  end

  test "building multi levelled expression with the same operator - (leftmost operations first)" do
    # add
    assert %Expression{left: 0, operator: :add, right: 3}
           |> Expression.add_operator(:add)
           |> Expression.add_value(7) ==
             %Expression{
               left: %Expression{left: 0, operator: :add, right: 3},
               operator: :add,
               right: 7
             }

    assert %Expression{
             left: %Expression{left: 10, operator: :add, right: 0},
             operator: :add,
             right: 3
           }
           |> Expression.add_operator(:add)
           |> Expression.add_value(7) ==
             %Expression{
               left: %Expression{
                 left: %Expression{left: 10, operator: :add, right: 0},
                 operator: :add,
                 right: 3
               },
               operator: :add,
               right: 7
             }

    # subtract
    assert %Expression{left: 0, operator: :subtract, right: 3}
           |> Expression.add_operator(:subtract)
           |> Expression.add_value(7) ==
             %Expression{
               left: %Expression{left: 0, operator: :subtract, right: 3},
               operator: :subtract,
               right: 7
             }

    assert %Expression{
             left: %Expression{left: 10, operator: :subtract, right: 0},
             operator: :subtract,
             right: 3
           }
           |> Expression.add_operator(:subtract)
           |> Expression.add_value(7) ==
             %Expression{
               left: %Expression{
                 left: %Expression{left: 10, operator: :subtract, right: 0},
                 operator: :subtract,
                 right: 3
               },
               operator: :subtract,
               right: 7
             }

    # multiply
    assert %Expression{left: 0, operator: :multiply, right: 3}
           |> Expression.add_operator(:multiply)
           |> Expression.add_value(7) ==
             %Expression{
               left: %Expression{left: 0, operator: :multiply, right: 3},
               operator: :multiply,
               right: 7
             }

    assert %Expression{
             left: %Expression{left: 10, operator: :multiply, right: 0},
             operator: :multiply,
             right: 3
           }
           |> Expression.add_operator(:multiply)
           |> Expression.add_value(7) ==
             %Expression{
               left: %Expression{
                 left: %Expression{left: 10, operator: :multiply, right: 0},
                 operator: :multiply,
                 right: 3
               },
               operator: :multiply,
               right: 7
             }

    # divide
    assert %Expression{left: 0, operator: :divide, right: 3}
           |> Expression.add_operator(:divide)
           |> Expression.add_value(7) ==
             %Expression{
               left: %Expression{left: 0, operator: :divide, right: 3},
               operator: :divide,
               right: 7
             }

    assert %Expression{
             left: %Expression{left: 10, operator: :divide, right: 0},
             operator: :divide,
             right: 3
           }
           |> Expression.add_operator(:divide)
           |> Expression.add_value(7) ==
             %Expression{
               left: %Expression{
                 left: %Expression{left: 10, operator: :divide, right: 0},
                 operator: :divide,
                 right: 3
               },
               operator: :divide,
               right: 7
             }
  end

  test "add and subtract have the same priority and will be left heavy (leftmost operations first)" do
    assert %Expression{left: 0, operator: :add, right: 3}
           |> Expression.add_operator(:subtract)
           |> Expression.add_value(7) ==
             %Expression{
               left: %Expression{left: 0, operator: :add, right: 3},
               operator: :subtract,
               right: 7
             }

    assert %Expression{left: 0, operator: :subtract, right: 3}
           |> Expression.add_operator(:add)
           |> Expression.add_value(7) ==
             %Expression{
               left: %Expression{left: 0, operator: :subtract, right: 3},
               operator: :add,
               right: 7
             }
  end

  test "multiply has priority over add and subtract" do
    assert %Expression{left: 0, operator: :add, right: 3}
           |> Expression.add_operator(:multiply)
           |> Expression.add_value(7) ==
             %Expression{
               left: 0,
               operator: :add,
               right: %Expression{left: 3, operator: :multiply, right: 7}
             }

    assert %Expression{left: 0, operator: :subtract, right: 3}
           |> Expression.add_operator(:multiply)
           |> Expression.add_value(7) ==
             %Expression{
               left: 0,
               operator: :subtract,
               right: %Expression{left: 3, operator: :multiply, right: 7}
             }
  end

  test "divide has priority over add and subtract" do
    assert %Expression{left: 0, operator: :add, right: 3}
           |> Expression.add_operator(:divide)
           |> Expression.add_value(7) ==
             %Expression{
               left: 0,
               operator: :add,
               right: %Expression{left: 3, operator: :divide, right: 7}
             }

    assert %Expression{left: 0, operator: :subtract, right: 3}
           |> Expression.add_operator(:divide)
           |> Expression.add_value(7) ==
             %Expression{
               left: 0,
               operator: :subtract,
               right: %Expression{left: 3, operator: :divide, right: 7}
             }
  end

  test "build complex expression given operator priorities - turned priority" do
    # 0+1*2+0+3*4+0+5/6
    result =
      @empty_expression
      |> Expression.add_value(0)
      |> Expression.add_operator(:add)
      |> Expression.add_value(1)
      |> Expression.add_operator(:multiply)
      |> Expression.add_value(2)
      |> Expression.add_operator(:add)
      |> Expression.add_value(0)
      |> Expression.add_operator(:add)
      |> Expression.add_value(3)
      |> Expression.add_operator(:multiply)
      |> Expression.add_value(4)
      |> Expression.add_operator(:add)
      |> Expression.add_value(0)
      |> Expression.add_operator(:add)
      |> Expression.add_value(5)
      |> Expression.add_operator(:divide)
      |> Expression.add_value(6)

    assert result == %Expression{
             left: %Expression{
               left: %Expression{
                 left: %Expression{
                   left: %Expression{
                     left: 0,
                     operator: :add,
                     right: %Expression{left: 1, operator: :multiply, right: 2}
                   },
                   operator: :add,
                   right: 0
                 },
                 operator: :add,
                 right: %Expression{left: 3, operator: :multiply, right: 4}
               },
               operator: :add,
               right: 0
             },
             operator: :add,
             right: %Expression{left: 5, operator: :divide, right: 6}
           }
  end

  test "build complex expression given operator priorities - turned priority with non-priority finish" do
    # 0+1*2+0+3*4-0
    result =
      @empty_expression
      |> Expression.add_value(0)
      |> Expression.add_operator(:add)
      |> Expression.add_value(1)
      |> Expression.add_operator(:multiply)
      |> Expression.add_value(2)
      |> Expression.add_operator(:add)
      |> Expression.add_value(0)
      |> Expression.add_operator(:add)
      |> Expression.add_value(3)
      |> Expression.add_operator(:multiply)
      |> Expression.add_value(4)
      |> Expression.add_operator(:subtract)
      |> Expression.add_value(0)

    assert result == %Expression{
             left: %Expression{
               left: %Expression{
                 left: %Expression{
                   left: 0,
                   operator: :add,
                   right: %Expression{left: 1, operator: :multiply, right: 2}
                 },
                 operator: :add,
                 right: 0
               },
               operator: :add,
               right: %Expression{left: 3, operator: :multiply, right: 4}
             },
             operator: :subtract,
             right: 0
           }
  end

  #  test "interpret expressions ending without a final term/number as bad input" do
  #    assert Interpreter.interpret("3+") == {:invalid_input, "Malformed expression"}
  #    assert Interpreter.interpret("3-") == {:invalid_input, "Malformed expression"}
  #    assert Interpreter.interpret("3*") == {:invalid_input, "Malformed expression"}
  #    assert Interpreter.interpret("3/") == {:invalid_input, "Malformed expression"}
  #  end
  #
end
