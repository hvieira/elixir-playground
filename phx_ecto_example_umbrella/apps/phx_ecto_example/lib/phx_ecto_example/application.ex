defmodule PhxEctoExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      PhxEctoExample.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: PhxEctoExample.PubSub}
      # Start a worker by calling: PhxEctoExample.Worker.start_link(arg)
      # {PhxEctoExample.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: PhxEctoExample.Supervisor)
  end
end
