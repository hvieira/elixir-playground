defmodule DummyProductApi.BaseModel do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
      # set generated timestamps to datetime with utc timezone
      # see also https://elixirforum.com/t/ecto-datetime-and-utc-naive-datetime-in-migration/21213/6
      # to see why ecto does not create the timestamp columns with timestamp with timezone but rather timestamp(0) without time zone
      # i.e.
      # For utc_datetime ecto does already ensure that the datetime is in the Etc/UTC timezone.
      # Other timezones cannot be set to those fields. What timezone with timestamp does is ensure that saved datetimes are in UTC and if not convert to UTC.
      # So for usage with ecto there’s actually no benefit to using timezone with timestamp at all, because everything is UTC all the time when it comes to what postgres is working with.
      # timezone with timestamp does contrary to it’s naming not retain the initial timezone it converted from.
      # So if you need to store a datetime in a timezone different to UTC you’ll need additional columns no matter what you chose.
      @timestamps_opts [type: :utc_datetime]
    end
  end
end
