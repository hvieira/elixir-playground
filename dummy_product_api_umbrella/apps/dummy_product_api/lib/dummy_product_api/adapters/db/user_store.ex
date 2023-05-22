defmodule DummyProductApi.UserStore do
  @callback create_user(user :: term) :: {:ok, user :: term} | {:error, reason :: term}
  @callback get_user_by_credentials(username :: String.t(), password :: String.t()) ::
              {:ok, user :: term} | {:error, reason :: term}
end

defmodule DummyProductApi.UserDatabaseStore do
  @behaviour DummyProductApi.UserStore

  alias DummyProductApi.Repo
  alias DummyProductApi.User

  import Ecto.Query

  def create_user(user_params) do
    changeset =
      %User{}
      |> User.changeset(user_params)

    Repo.insert(changeset)
  end

  def get_user_by_credentials(username, password) do
    with user <-
           Repo.one(from u in User, where: u.username == ^username and u.password == ^password) do
      {:ok, user}
    end
  end
end
