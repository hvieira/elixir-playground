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

  test "user can update own products", %{conn: conn} do
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

  test "sending ID in the update request does not update the product ID", %{conn: conn} do
    {:ok, user} =
      Repo.insert(
        User.changeset(%User{}, %{
          name: "Test",
          username: "test",
          password: "test"
        })
      )

    user_id = user.id

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
        id: "some ID that is not supposed to be considered",
        name: "changed name",
        description: "changed description",
        value: 113
      })

    # assert response structure
    %{
      "data" => %{
        "id" => product_id
      }
    } = json_response(response, 200)

    updated_product = Repo.get!(Product, product_id)

    assert updated_product.id != "some ID that is not supposed to be considered"
    assert updated_product.id == product_id
  end

  test "user cannot update products that they dont own", %{conn: conn} do
    {:ok, user1} =
      Repo.insert(
        User.changeset(%User{}, %{
          name: "Test",
          username: "test",
          password: "test"
        })
      )

    owner_user_id = user1.id

    {:ok, user2} =
      Repo.insert(
        User.changeset(%User{}, %{
          name: "Test 2",
          username: "test 2",
          password: "test 2"
        })
      )

    # create owned product by user 1
    {:ok, product} =
      Ecto.build_assoc(user1, :products, %{
        name: "product by #{owner_user_id}",
        description: "amazing product by #{owner_user_id}. It's really great!",
        value: 100
      })
      |> Repo.insert()

    # try to update product as user 2
    {:ok, token, _claims} =
      JWT.generate_and_sign(
        %{sub: user2.id},
        :new_signer
      )

    response =
      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> patch("/api/products/#{product.id}", %{
        name: "changed name",
        description: "changed description",
        value: 100_000
      })

    # assert response structure
    %{
      "message" => "Forbidden"
    } = json_response(response, 403)
  end

  test "updating a non existing product returns a not found 404", %{conn: conn} do
    {:ok, user} =
      Repo.insert(
        User.changeset(%User{}, %{
          name: "Test",
          username: "test",
          password: "test"
        })
      )

    {:ok, token, _claims} =
      JWT.generate_and_sign(
        %{sub: user.id},
        :new_signer
      )

    non_existing_product_id = UUID.uuid4()

    response =
      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> patch("/api/products/#{non_existing_product_id}", %{
        name: "changed name",
        description: "changed description",
        value: 100_000
      })

    # assert response structure
    %{
      "message" => "Not Found"
    } = json_response(response, 404)
  end

  test "updating a product with non existing user returns a 401", %{conn: conn} do
    {:ok, user} =
      Repo.insert(
        User.changeset(%User{}, %{
          name: "Test",
          username: "test",
          password: "test"
        })
      )
      {:ok, product} =
        Ecto.build_assoc(user, :products, %{
          name: "product by #{user.id}",
          description: "amazing product by #{user.id}. It's really great!",
          value: 100
        })
        |> Repo.insert()

      # very small change of UUID clash here
    {:ok, token, _claims} =
      JWT.generate_and_sign(
        %{sub: UUID.uuid4()},
        :new_signer
      )

    response =
      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> patch("/api/products/#{product.id}", %{
        name: "changed name",
        description: "changed description",
        value: 100_000
      })

    assert response.status == 401
  end
end
