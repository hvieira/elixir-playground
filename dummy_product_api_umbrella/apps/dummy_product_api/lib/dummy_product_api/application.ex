defmodule DummyProductApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      DummyProductApi.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: DummyProductApi.PubSub}
      # Start a worker by calling: DummyProductApi.Worker.start_link(arg)
      # {DummyProductApi.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: DummyProductApi.Supervisor)
  end
end
