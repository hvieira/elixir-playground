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
             product
           )
  end

  test "user can edit own products", %{conn: conn} do
    {:ok, user} =
      Repo.insert(
        User.changeset(%User{}, %{
          name: "Test",
          username: "test",
          password: "test"
        })
      )

    user_id = user.id
    new_product_name = "changed name"
    new_product_description = "changed description"
    new_product_value = 113

    IO.inspect(user_id)

    # create owned product
    {:ok, product} =
      Ecto.build_assoc(user, :products, %{
        name: "product by #{user_id}",
        description: "amazing product by #{user_id}. It's really great!",
        value: 100
      })
      |> Repo.insert()

    {:ok, token, _claims} =
      JWT.generate_and_sign(
        %{sub: user_id},
        :new_signer
      )

    response =
      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> patch("/api/products/#{product.id}", %{
        name: new_product_name,
        description: new_product_description,
        value: new_product_value
      })

    # assert response structure
    %{
      "data" => %{
        "id" => product_id,
        "name" => new_product_name,
        "description" => new_product_description,
        "value" => new_product_value
      }
    } = json_response(response, 200)

    # assert data in database is valid and with correct associations
    updated_product = Repo.get!(Product, product_id)

    assert match?(
             %{
               id: ^product_id,
               name: ^new_product_name,
               description: ^new_product_description,
               value: ^new_product_value,
               owner_user_id: ^user_id
             },
             updated_product
           )
  end

  # TODO test update does not update the ID of the product
  # TODO test user cannot update products that they do not own
end
