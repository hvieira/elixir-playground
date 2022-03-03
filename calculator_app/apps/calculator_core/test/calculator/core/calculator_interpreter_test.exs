defmodule CalculatorInterpreterTest do
  use ExUnit.Case, async: true

  alias Calculator.Core.Interpreter
  alias Calculator.Core.Expression

  test "interpret single numbers" do
    assert Interpreter.interpret("1") == 1
    assert Interpreter.interpret("3") == 3
    assert Interpreter.interpret("1083") == 1083
    assert Interpreter.interpret("7.3") == 7.3
    assert Interpreter.interpret("0.57") == 0.57
    assert Interpreter.interpret("217.57") == 217.57
  end

  test "interpret single numbers with preceding negative sign" do
    assert Interpreter.interpret("-1") == %Expression{
             within_parens: true,
             left: 0,
             operator: :subtract,
             right: 1
           }

    assert Interpreter.interpret("-3") == %Expression{
             within_parens: true,
             left: 0,
             operator: :subtract,
             right: 3
           }

    assert Interpreter.interpret("-1083") == %Expression{
             within_parens: true,
             left: 0,
             operator: :subtract,
             right: 1083
           }

    assert Interpreter.interpret("-7.3") == %Expression{
             within_parens: true,
             left: 0,
             operator: :subtract,
             right: 7.3
           }

    assert Interpreter.interpret("-0.57") == %Expression{
             within_parens: true,
             left: 0,
             operator: :subtract,
             right: 0.57
           }

    assert Interpreter.interpret("-217.57") == %Expression{
             within_parens: true,
             left: 0,
             operator: :subtract,
             right: 217.57
           }
  end

  test "interpret single numbers with preceding positive sign" do
    assert Interpreter.interpret("+1") == %Expression{
             within_parens: true,
             left: 0,
             operator: :add,
             right: 1
           }

    assert Interpreter.interpret("+3") == %Expression{
             within_parens: true,
             left: 0,
             operator: :add,
             right: 3
           }

    assert Interpreter.interpret("+1083") == %Expression{
             within_parens: true,
             left: 0,
             operator: :add,
             right: 1083
           }

    assert Interpreter.interpret("+7.3") == %Expression{
             within_parens: true,
             left: 0,
             operator: :add,
             right: 7.3
           }

    assert Interpreter.interpret("+0.57") == %Expression{
             within_parens: true,
             left: 0,
             operator: :add,
             right: 0.57
           }

    assert Interpreter.interpret("+217.57") == %Expression{
             within_parens: true,
             left: 0,
             operator: :add,
             right: 217.57
           }
  end

  test "interpret expressions starting with multiply operator as bad input" do
    assert Interpreter.interpret("*3") == {:invalid_input, "Malformed expression"}
    assert Interpreter.interpret("*0.0") == {:invalid_input, "Malformed expression"}
  end

  test "interpret expressions starting with divide operator as bad input" do
    assert Interpreter.interpret("/3") == {:invalid_input, "Malformed expression"}
    assert Interpreter.interpret("/0.0") == {:invalid_input, "Malformed expression"}
  end

  test "interpret expressions with a single add operand" do
    assert Interpreter.interpret("0+3") == %Expression{left: 0, operator: :add, right: 3}
    assert Interpreter.interpret("3+0") == %Expression{left: 3, operator: :add, right: 0}
    assert Interpreter.interpret("7.3+5.1") == %Expression{left: 7.3, operator: :add, right: 5.1}
  end

  test "interpret expressions with a single subtract operand" do
    assert Interpreter.interpret("0-3") == %Expression{left: 0, operator: :subtract, right: 3}
    assert Interpreter.interpret("3-0") == %Expression{left: 3, operator: :subtract, right: 0}

    assert Interpreter.interpret("7.3-5.1") == %Expression{
             left: 7.3,
             operator: :subtract,
             right: 5.1
           }
  end

  test "interpret expressions with a single multiply operand" do
    assert Interpreter.interpret("0*3") == %Expression{left: 0, operator: :multiply, right: 3}
    assert Interpreter.interpret("3*0") == %Expression{left: 3, operator: :multiply, right: 0}

    assert Interpreter.interpret("7.3*5.1") == %Expression{
             left: 7.3,
             operator: :multiply,
             right: 5.1
           }
  end

  #
  test "interpret expressions with a single divide operand" do
    assert Interpreter.interpret("0/3") == %Expression{left: 0, operator: :divide, right: 3}
    assert Interpreter.interpret("3/0") == %Expression{left: 3, operator: :divide, right: 0}

    assert Interpreter.interpret("7.3/5.1") == %Expression{
             left: 7.3,
             operator: :divide,
             right: 5.1
           }
  end

  test "interpret expressions ending without a final term/number as bad input" do
    assert Interpreter.interpret("3+") == {:invalid_input, "Malformed expression"}
    assert Interpreter.interpret("3-") == {:invalid_input, "Malformed expression"}
    assert Interpreter.interpret("3*") == {:invalid_input, "Malformed expression"}
    assert Interpreter.interpret("3/") == {:invalid_input, "Malformed expression"}
  end

  test "interpret expressions with a multiple add operations" do
    assert Interpreter.interpret("0+3+7") == %Expression{
             left: %Expression{left: 0, operator: :add, right: 3},
             operator: :add,
             right: 7
           }

    assert Interpreter.interpret("0+3+7+13+0.37") == %Expression{
             left: %Expression{
               left: %Expression{
                 left: %Expression{
                   left: 0,
                   operator: :add,
                   right: 3
                 },
                 operator: :add,
                 right: 7
               },
               operator: :add,
               right: 13
             },
             operator: :add,
             right: 0.37
           }
  end

  test "interpret expressions with a multiple subtract operations" do
    assert Interpreter.interpret("0-3-7") == %Expression{
             left: %Expression{left: 0, operator: :subtract, right: 3},
             operator: :subtract,
             right: 7
           }

    assert Interpreter.interpret("0-3-7-13-0.37") == %Expression{
             left: %Expression{
               left: %Expression{
                 left: %Expression{
                   left: 0,
                   operator: :subtract,
                   right: 3
                 },
                 operator: :subtract,
                 right: 7
               },
               operator: :subtract,
               right: 13
             },
             operator: :subtract,
             right: 0.37
           }
  end

  test "interpret expressions with a multiple multiply operations" do
    assert Interpreter.interpret("0*3*7") == %Expression{
             left: %Expression{left: 0, operator: :multiply, right: 3},
             operator: :multiply,
             right: 7
           }

    assert Interpreter.interpret("0*3*7*13*0.37") == %Expression{
             left: %Expression{
               left: %Expression{
                 left: %Expression{
                   left: 0,
                   operator: :multiply,
                   right: 3
                 },
                 operator: :multiply,
                 right: 7
               },
               operator: :multiply,
               right: 13
             },
             operator: :multiply,
             right: 0.37
           }
  end

  test "interpret expressions with a multiple divide operations" do
    assert Interpreter.interpret("0/3/7") == %Expression{
             left: %Expression{left: 0, operator: :divide, right: 3},
             operator: :divide,
             right: 7
           }

    assert Interpreter.interpret("0/3/7/13/0.37") == %Expression{
             left: %Expression{
               left: %Expression{
                 left: %Expression{
                   left: 0,
                   operator: :divide,
                   right: 3
                 },
                 operator: :divide,
                 right: 7
               },
               operator: :divide,
               right: 13
             },
             operator: :divide,
             right: 0.37
           }
  end

  test "interpret expressions with a multiple add AND subtract operations" do
    assert Interpreter.interpret("0+3-7-13+0.37") == %Expression{
             left: %Expression{
               left: %Expression{
                 left: %Expression{
                   left: 0,
                   operator: :add,
                   right: 3
                 },
                 operator: :subtract,
                 right: 7
               },
               operator: :subtract,
               right: 13
             },
             operator: :add,
             right: 0.37
           }
  end

  test "interpret expressions where priority needs to take place - multiply" do
    assert Interpreter.interpret("0+3*7") ==
             %Expression{
               left: 0,
               operator: :add,
               right: %Expression{left: 3, operator: :multiply, right: 7}
             }

    assert Interpreter.interpret("7*3-1") ==
             %Expression{
               left: %Expression{left: 7, operator: :multiply, right: 3},
               operator: :subtract,
               right: 1
             }
  end

  test "interpret expressions where priority needs to take place - divide" do
    assert Interpreter.interpret("0+3/7") ==
             %Expression{
               left: 0,
               operator: :add,
               right: %Expression{left: 3, operator: :divide, right: 7}
             }

    assert Interpreter.interpret("7/3-1") ==
             %Expression{
               left: %Expression{left: 7, operator: :divide, right: 3},
               operator: :subtract,
               right: 1
             }
  end

  test "interpret expressions where priority needs to take place - multiply and divide first and others left to right" do
    assert Interpreter.interpret("0+1*2-3/7") ==
             %Expression{
               left: %Expression{
                 left: 0,
                 operator: :add,
                 right: %Expression{left: 1, operator: :multiply, right: 2}
               },
               operator: :subtract,
               right: %Expression{
                 left: 3,
                 operator: :divide,
                 right: 7
               }
             }

    assert Interpreter.interpret("7/3-1*2") ==
             %Expression{
               left: %Expression{left: 7, operator: :divide, right: 3},
               operator: :subtract,
               right: %Expression{left: 1, operator: :multiply, right: 2}
             }
  end

  test "handles bad input" do
    assert match?({:invalid_input, _}, Interpreter.interpret(""))
    assert match?({:invalid_input, _}, Interpreter.interpret("hack"))
    assert match?({:invalid_input, _}, Interpreter.interpret("l33t"))
    assert match?({:invalid_input, _}, Interpreter.interpret("l3+3t"))
    assert match?({:invalid_input, _}, Interpreter.interpret("l33t/2"))
    assert match?({:invalid_input, _}, Interpreter.interpret("1/2l33t"))

    assert match?(
             {:invalid_input, _},
             Interpreter.interpret("1 + some random text")
           )

    assert match?({:invalid_input, _}, Interpreter.interpret("1 # 2"))
    assert match?({:invalid_input, _}, Interpreter.interpret("1 \\ 2"))
    assert match?({:invalid_input, _}, Interpreter.interpret("1 2"))

    assert match?({:invalid_input, _}, Interpreter.interpret("1 +"))
  end

  test "can interpret expressions within parentheses - single enclosed expression" do
    assert Interpreter.interpret("(3+5)") ==
             %Expression{
               within_parens: true,
               left: 3,
               operator: :add,
               right: 5
             }

    assert Interpreter.interpret("(3+5-8*5/1)") ==
             %Expression{
               within_parens: true,
               left: %Expression{left: 3, operator: :add, right: 5},
               operator: :subtract,
               right: %Expression{
                 left: %Expression{left: 8, operator: :multiply, right: 5},
                 operator: :divide,
                 right: 1
               }
             }
  end

  test "can interpret expressions with parentheses - multiple enclosed expression" do
    assert Interpreter.interpret("(3+5)/(8-0)") ==
             %Expression{
               left: %Expression{within_parens: true, left: 3, operator: :add, right: 5},
               operator: :divide,
               right: %Expression{within_parens: true, left: 8, operator: :subtract, right: 0}
             }

    assert Interpreter.interpret("(3+5)/(8-0)-1") ==
             %Expression{
               within_parens: false,
               left: %Expression{
                 left: %Expression{within_parens: true, left: 3, operator: :add, right: 5},
                 operator: :divide,
                 right: %Expression{within_parens: true, left: 8, operator: :subtract, right: 0}
               },
               operator: :subtract,
               right: 1
             }

    assert Interpreter.interpret("(3+5)/(8-0)*(300+7)") ==
             %Expression{
               within_parens: false,
               left: %Expression{
                 left: %Expression{within_parens: true, left: 3, operator: :add, right: 5},
                 operator: :divide,
                 right: %Expression{within_parens: true, left: 8, operator: :subtract, right: 0}
               },
               operator: :multiply,
               right: %Expression{within_parens: true, left: 300, operator: :add, right: 7}
             }
  end

  test "can interpret expressions with nested parentheses" do
    assert Interpreter.interpret("((4+7)-1)") ==
             %Expression{
               within_parens: true,
               left: %Expression{within_parens: true, left: 4, operator: :add, right: 7},
               operator: :subtract,
               right: 1
             }

    assert Interpreter.interpret("(1+(4+7))-(1/(1*1))") ==
             %Expression{
               left: %Expression{
                 within_parens: true,
                 left: 1,
                 operator: :add,
                 right: %Expression{
                   within_parens: true,
                   left: 4,
                   operator: :add,
                   right: 7
                 }
               },
               operator: :subtract,
               right: %Expression{
                 within_parens: true,
                 left: 1,
                 operator: :divide,
                 right: %Expression{within_parens: true, left: 1, operator: :multiply, right: 1}
               }
             }
  end

    test "invalid input when subsequent signs are invalid" do
      assert match?({:invalid_input, _}, Interpreter.interpret("1//1"))
      assert match?({:invalid_input, _}, Interpreter.interpret("1+//1"))
      assert match?({:invalid_input, _}, Interpreter.interpret("1-//1"))
      assert match?({:invalid_input, _}, Interpreter.interpret("1**1"))
      assert match?({:invalid_input, _}, Interpreter.interpret("1+**1"))
      assert match?({:invalid_input, _}, Interpreter.interpret("1-**1"))
    end

    test "invalid input when parentheses are unbalanced" do
      expected_error_msg = "Malformed expression. Parentheses are unbalanced"

      assert Interpreter.interpret("(1+1") == {:invalid_input, expected_error_msg}
      assert Interpreter.interpret("1+1)") == {:invalid_input, expected_error_msg}
      assert Interpreter.interpret("((1+1((0+0))") == {:invalid_input, expected_error_msg}
      assert Interpreter.interpret("((1+1)((0+0)") == {:invalid_input, expected_error_msg}
    end
end
