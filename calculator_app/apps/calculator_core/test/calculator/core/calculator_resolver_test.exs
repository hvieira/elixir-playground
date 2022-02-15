defmodule CalculatorCoreResolverTest do
  use ExUnit.Case
  alias Calculator.Core.Resolver
  alias Calculator.Core.Expression

  doctest Resolver

  test "Can simple expressions" do
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
    assert Resolver.resolve(%Expression{
             left: %Expression{left: 7, operator: :add, right: 6},
             operator: :add,
             right: 1
           }) == 14

    assert Resolver.resolve(%Expression{
             left: 1,
             operator: :add,
             right: %Expression{left: 2, operator: :add, right: 3}
           }) == 6

    assert Resolver.resolve(%Expression{
             left: %Expression{left: 3.81, operator: :add, right: 3.81},
             operator: :add,
             right: %Expression{left: 3.81, operator: :add, right: 3.81}
           }) == 3.81 * 4
  end

  test "Can resolve expressions that have multiple consecutive operations - subtract" do
    assert Resolver.resolve(%Expression{
             left: %Expression{left: 7, operator: :subtract, right: 6},
             operator: :subtract,
             right: 1
           }) == 0

    assert Resolver.resolve(%Expression{
             left: 1,
             operator: :subtract,
             right: %Expression{left: 2, operator: :subtract, right: 3}
           }) == 2

    assert Resolver.resolve(%Expression{
             left: %Expression{left: 3.81, operator: :subtract, right: 3.81},
             operator: :subtract,
             right: %Expression{left: 3.81, operator: :subtract, right: 3.81}
           }) == 0
  end

  test "Can resolve expressions that have multiple consecutive operations - multiply" do
    assert Resolver.resolve(%Expression{
             left: %Expression{left: 7, operator: :multiply, right: 6},
             operator: :multiply,
             right: 1
           }) == 42

    assert Resolver.resolve(%Expression{
             left: 1,
             operator: :multiply,
             right: %Expression{left: 2, operator: :multiply, right: 3}
           }) == 6

    assert Resolver.resolve(%Expression{
             left: %Expression{left: 3.81, operator: :multiply, right: 3.81},
             operator: :multiply,
             right: %Expression{left: 3.81, operator: :multiply, right: 3.81}
           }) == Float.pow(3.81, 4)
  end

  test "Can resolve expressions that have multiple consecutive operations - divide" do
    assert Resolver.resolve(%Expression{
             left: %Expression{left: 7, operator: :divide, right: 6},
             operator: :divide,
             right: 1
           }) == 7 / 6 / 1

    assert Resolver.resolve(%Expression{
             left: 1,
             operator: :divide,
             right: %Expression{left: 2, operator: :divide, right: 3}
           }) == 1 / (2 / 3)

    assert Resolver.resolve(%Expression{
             left: %Expression{left: 3.81, operator: :divide, right: 3.81},
             operator: :divide,
             right: %Expression{left: 3.81, operator: :divide, right: 3.81}
           }) == 1
  end

  test "Resolves expressions by resolving whatever is within parentheses first" do
    assert Resolver.resolve(%Expression{
             within_parens: true,
             left: 1,
             operator: :add,
             right: 1
           }) == 2

    assert Resolver.resolve(%Expression{
             left: %Expression{within_parens: true, left: 3, operator: :subtract, right: 1},
             operator: :multiply,
             right: 100
           }) == 200

    assert Resolver.resolve(%Expression{
             left: 1,
             operator: :divide,
             right: %Expression{within_parens: true, left: 3, operator: :subtract, right: 1}
           }) == 1 / 2

    assert Resolver.resolve(%Expression{
             left: %Expression{within_parens: true, left: 2, operator: :multiply, right: 100},
             operator: :divide,
             right: %Expression{within_parens: true, left: 400, operator: :divide, right: 2}
           }) == 1

    assert Resolver.resolve(%Expression{
             left: %Expression{left: 1, operator: :add, right: 2},
             operator: :divide,
             right: %Expression{within_parens: true, left: 1, operator: :subtract, right: 6}
           }) == 3 / (1 - 6)
  end

  test "Resolves expressions by resolving whatever is within parentheses first - nested " do
    assert Resolver.resolve(%Expression{
             within_parens: true,
             left: 1,
             operator: :add,
             right: %Expression{
               left: 2,
               operator: :multiply,
               right: %Expression{
                 within_parens: true,
                 left: 1,
                 operator: :add,
                 right: %Expression{
                   left: 1,
                   operator: :add,
                   right: %Expression{
                     left: 1,
                     operator: :add,
                     right: 1
                   }
                 }
               }
             }
           }) == 1 + 2 * (1 + 1 + 1 + 1)
  end
end
