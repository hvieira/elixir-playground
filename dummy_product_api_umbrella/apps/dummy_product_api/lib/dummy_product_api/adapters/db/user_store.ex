defmodule DummyProductApi.UserStore do
  @callback create_user(user :: term) :: {:ok, user :: term} | {:error, reason :: term}
end

defmodule DummyProductApi.UserDatabaseStore do
  @behaviour DummyProductApi.UserStore

  alias DummyProductApi.Repo
  alias DummyProductApi.User

  def create_user(user_params) do
    changeset =
      %User{}
      |> User.changeset(user_params)

    Repo.insert(changeset)
  end
end
