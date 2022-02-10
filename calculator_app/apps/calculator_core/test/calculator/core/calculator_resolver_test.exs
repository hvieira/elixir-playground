defmodule CalculatorCoreResolverTest do
  use ExUnit.Case
  alias Calculator.Core.Resolver
  alias Calculator.Core.Expression

  doctest Resolver

  test "Can simple expressions" do
    assert Resolver.resolve_expression(%Expression{
             left: 3,
             operator: :add,
             right: 7
           }) == 10

    assert Resolver.resolve_expression(%Expression{
             left: 3,
             operator: :subtract,
             right: 5
           }) == -2

    assert Resolver.resolve_expression(%Expression{
             left: 1,
             operator: :multiply,
             right: 1
           }) == 1

    assert Resolver.resolve_expression(%Expression{
             left: 5,
             operator: :divide,
             right: 2
           }) == 2.5
  end

  test "Can resolve expressions that have multiple consecutive operations - add" do
    assert Resolver.resolve_expression(%Expression{
             left: %Expression{left: 7, operator: :add, right: 6},
             operator: :add,
             right: 1
           }) == 14

    assert Resolver.resolve_expression(%Expression{
             left: 1,
             operator: :add,
             right: %Expression{left: 2, operator: :add, right: 3}
           }) == 6

    assert Resolver.resolve_expression(%Expression{
             left: %Expression{left: 3.81, operator: :add, right: 3.81},
             operator: :add,
             right: %Expression{left: 3.81, operator: :add, right: 3.81}
           }) == 3.81 * 4

    #    assert Resolver.resolve_expression(%Expression{
    #             left: %Expression{left: 3.81, operator: :multiply, right: 5},
    #             operator: :multiply,
    #             right: 2
    #           }) == 38.1
    #
    #    assert Resolver.resolve_expression(%Expression{
    #             left: %Expression{left: 1, operator: :divide, right: 1},
    #             operator: :divide,
    #             right: %Expression{left: 2, operator: :divide, right: 1}
    #           }) == 0.5
  end
end
