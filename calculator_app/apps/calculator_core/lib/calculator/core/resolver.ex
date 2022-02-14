defmodule Calculator.Core.Resolver do
  alias Calculator.Core.Expression

  ### add ###
  def resolve_expression(%Expression{left: l, operator: :add, right: r})
      when is_number(l) and is_number(r),
      do: l + r

  def resolve_expression(%Expression{left: l, operator: :add, right: r})
      when is_number(l),
      do: l + resolve_expression(r)

  def resolve_expression(%Expression{left: l, operator: :add, right: r})
      when is_number(r),
      do: resolve_expression(l) + r

  def resolve_expression(%Expression{left: l, operator: :add, right: r}),
    do: resolve_expression(l) + resolve_expression(r)

  ### subtract ###
  def resolve_expression(%Expression{left: l, operator: :subtract, right: r})
      when is_number(l) and is_number(r),
      do: l - r

  def resolve_expression(%Expression{left: l, operator: :subtract, right: r})
      when is_number(l),
      do: l - resolve_expression(r)

  def resolve_expression(%Expression{left: l, operator: :subtract, right: r})
      when is_number(r),
      do: resolve_expression(l) - r

  def resolve_expression(%Expression{left: l, operator: :subtract, right: r}),
    do: resolve_expression(l) - resolve_expression(r)

  ### multiply ###
  def resolve_expression(%Expression{left: l, operator: :multiply, right: r})
      when is_number(l) and is_number(r),
      do: l * r

  def resolve_expression(%Expression{left: l, operator: :multiply, right: r})
      when is_number(l),
      do: l * resolve_expression(r)

  def resolve_expression(%Expression{left: l, operator: :multiply, right: r})
      when is_number(r),
      do: resolve_expression(l) * r

  def resolve_expression(%Expression{left: l, operator: :multiply, right: r}),
    do: resolve_expression(l) * resolve_expression(r)

  ### divide ###
  def resolve_expression(%Expression{left: l, operator: :divide, right: r})
      when is_number(l) and is_number(r),
      do: l / r

  def resolve_expression(%Expression{left: l, operator: :divide, right: r})
      when is_number(l),
      do: l / resolve_expression(r)

  def resolve_expression(%Expression{left: l, operator: :divide, right: r})
      when is_number(r),
      do: resolve_expression(l) / r

  def resolve_expression(%Expression{left: l, operator: :divide, right: r}),
      do: resolve_expression(l) / resolve_expression(r)

end
