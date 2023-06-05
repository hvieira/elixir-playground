defmodule DummyProductApiWeb.ProductControllerIntegrationTest do
  use DummyProductApiWeb.ConnCase, async: true

  @moduletag :integration

  alias DummyProductApi.Repo
  alias DummyProductApi.User
  alias DummyProductApi.Product
  alias DummyProductApiWeb.Auth.JWT

  @product_name "bananas"
  @product_description "A cache of bananas. Delicious"
  @product_price 1200

  test "user creates product", %{conn: conn} do
    {:ok, user} =
      Repo.insert(
        User.changeset(%User{}, %{
          name: "Test",
          username: "test",
          password: "test"
        })
      )

    user_id = user.id

    {:ok, token, _claims} =
      JWT.generate_and_sign(
        %{sub: user_id},
        :new_signer
      )

    response =
      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> post("/api/products", %{
        name: @product_name,
        description: @product_description,
        value: @product_price
      })

    # assert response structure
    %{
      "data" => %{
        "id" => product_id,
        "name" => @product_name,
        "description" => @product_description,
        "value" => @product_price
      }
    } = json_response(response, 200)

    # assert data in database is valid and with correct associations
    product = Repo.get!(Product, product_id)
    assert match?(
      %{
        id: ^product_id,
        name: @product_name,
        description: @product_description,
        value: @product_price,
        owner_user_id: ^user_id
      },
      product)
  end

  # TODO test user ownership - can only update and delete owned products
end
