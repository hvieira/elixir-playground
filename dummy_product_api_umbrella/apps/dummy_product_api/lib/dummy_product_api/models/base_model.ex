defmodule DummyProductApi.BaseModel do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
      # set generated timestamps to datetime with utc timezone
      @timestamps_opts [type: :utc_datetime_usec]
    end
  end
end
