defmodule DummyProductApi.UserStore do
  alias DummyProductApi.Repo
  alias DummyProductApi.User

  # TODO define behaviour for this that can be mocked

  def create_user(user_params) do
    changeset =
      %User{}
      |> User.changeset(user_params)

    Repo.insert(changeset)
  end
end
