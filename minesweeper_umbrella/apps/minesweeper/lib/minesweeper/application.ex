defmodule Minesweeper.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {DNSCluster, query: Application.get_env(:minesweeper, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Minesweeper.PubSub}
      # Start a worker by calling: Minesweeper.Worker.start_link(arg)
      # {Minesweeper.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Minesweeper.Supervisor)
  end
end
