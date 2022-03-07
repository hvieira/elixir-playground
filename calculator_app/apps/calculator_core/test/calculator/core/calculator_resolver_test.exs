defmodule CalculatorCoreResolverTest do
  use ExUnit.Case
  alias Calculator.Core.Resolver
  alias Calculator.Core.Expression

  doctest Resolver

  @empty_expr %Expression{}

  test "Resolve simple expressions" do
    assert Resolver.resolve(%Expression{
             left: 3,
             operator: :add,
             right: 7
           }) == 10

    assert Resolver.resolve(%Expression{
             left: 3,
             operator: :subtract,
             right: 5
           }) == -2

    assert Resolver.resolve(%Expression{
             left: 1,
             operator: :multiply,
             right: 1
           }) == 1

    assert Resolver.resolve(%Expression{
             left: 5,
             operator: :divide,
             right: 2
           }) == 2.5
  end

  test "Can resolve expressions that have multiple consecutive operations - add" do
    expr =
      Expression.add_value(@empty_expr, 1)
      |> Expression.add_operator(:add)
      |> Expression.add_value(2)
      |> Expression.add_operator(:add)
      |> Expression.add_value(0.6)
      |> Expression.add_operator(:add)
      |> Expression.add_value(3)

    assert Resolver.resolve(expr) == 1 + 2 + 0.6 + 3
  end

  test "Can resolve expressions that have multiple consecutive operations - subtract" do
    expr =
      Expression.add_value(@empty_expr, 1)
      |> Expression.add_operator(:subtract)
      |> Expression.add_value(2)
      |> Expression.add_operator(:subtract)
      |> Expression.add_value(0.6)
      |> Expression.add_operator(:subtract)
      |> Expression.add_value(3)

    assert Resolver.resolve(expr) == 1 - 2 - 0.6 - 3
  end

  test "Can resolve expressions that have multiple consecutive operations - multiply" do
    expr =
      Expression.add_value(@empty_expr, 1)
      |> Expression.add_operator(:multiply)
      |> Expression.add_value(2)
      |> Expression.add_operator(:multiply)
      |> Expression.add_value(0.6)
      |> Expression.add_operator(:multiply)
      |> Expression.add_value(3)

    assert Resolver.resolve(expr) == 1 * 2 * 0.6 * 3
  end

  test "Can resolve expressions that have multiple consecutive operations - divide" do
    expr =
      Expression.add_value(@empty_expr, 1)
      |> Expression.add_operator(:divide)
      |> Expression.add_value(2)
      |> Expression.add_operator(:divide)
      |> Expression.add_value(0.6)
      |> Expression.add_operator(:divide)
      |> Expression.add_value(3)

    assert Resolver.resolve(expr) == 1 / 2 / 0.6 / 3
  end

  test "Resolves expressions by resolving whatever is within parentheses first" do
    expr =
      Expression.add_value(@empty_expr, 1)
      |> Expression.add_operator(:add)
      |> Expression.add_value(2)
      |> Expression.add_operator(:add)
      |> Expression.add_parentheses_encapsulated_expression(
        Expression.add_value(@empty_expr, 1)
        |> Expression.add_operator(:add)
        |> Expression.add_value(1)
        |> Expression.add_operator(:add)
        |> Expression.add_value(1)
        |> Expression.add_operator(:add)
        |> Expression.add_value(1)
      )

    assert Resolver.resolve(expr) == 1 + 2 + (1 + 1 + 1 + 1)
  end

  test "Resolves expressions by resolving whatever is within parentheses first - nested" do
    expr =
      Expression.add_parentheses_encapsulated_expression(
        @empty_expr,
        Expression.add_parentheses_encapsulated_expression(
          @empty_expr,
          Expression.add_value(@empty_expr, 1)
          |> Expression.add_operator(:add)
          |> Expression.add_value(2)
        )
        |> Expression.add_operator(:add)
        |> Expression.add_parentheses_encapsulated_expression(
          Expression.add_value(@empty_expr, 1)
          |> Expression.add_operator(:divide)
          |> Expression.add_parentheses_encapsulated_expression(
            Expression.add_value(@empty_expr, 1)
            |> Expression.add_operator(:add)
            |> Expression.add_value(1)
            |> Expression.add_operator(:add)
            |> Expression.add_value(1)
          )
        )
      )

    # mix format seems to remove the unnecessary parentheses that encapsulate the whole expression
    assert Resolver.resolve(expr) == 1 + 2 + 1 / (1 + 1 + 1)
  end

  test "Resolves expressions by prioritizing multiply and divide, left to right" do
    expr_with_multiply_first =
      Expression.add_value(@empty_expr, 5)
      |> Expression.add_operator(:subtract)
      |> Expression.add_value(2)
      |> Expression.add_operator(:multiply)
      |> Expression.add_value(2)
      |> Expression.add_operator(:add)
      |> Expression.add_value(3)
      |> Expression.add_operator(:divide)
      |> Expression.add_value(3)

    assert Resolver.resolve(expr_with_multiply_first) == 5 - 2 * 2 + 3 / 3

    expr_with_divide_first =
      Expression.add_value(@empty_expr, 5)
      |> Expression.add_operator(:subtract)
      |> Expression.add_value(2)
      |> Expression.add_operator(:divide)
      |> Expression.add_value(2)
      |> Expression.add_operator(:add)
      |> Expression.add_value(3)
      |> Expression.add_operator(:multiply)
      |> Expression.add_value(3)

    assert Resolver.resolve(expr_with_divide_first) == 5 - 2 / 2 + 3 * 3
  end

  test "Resolves expressions by resolving whatever is within parentheses first, then operator priority and left to right" do
    expr =
      Expression.add_parentheses_encapsulated_expression(
        @empty_expr,
        Expression.add_value(@empty_expr, 1)
        |> Expression.add_operator(:add)
        |> Expression.add_value(2)
      )
      |> Expression.add_operator(:multiply)
      |> Expression.add_parentheses_encapsulated_expression(
        Expression.add_value(@empty_expr, 1)
        |> Expression.add_operator(:divide)
        |> Expression.add_parentheses_encapsulated_expression(
          Expression.add_value(@empty_expr, 1)
          |> Expression.add_operator(:divide)
          |> Expression.add_value(1)
          |> Expression.add_operator(:multiply)
          |> Expression.add_value(2)
        )
      )

    # mix format seems to remove the unnecessary parentheses that encapsulate the whole expression
    assert Resolver.resolve(expr) == (1 + 2) * (1 / (1 / 1 * 2))
  end
end
