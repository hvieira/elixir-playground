defmodule Calculator.Core.DivideAgent do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(init_arg) do
    {:ok, init_arg}
  end

  @impl true
  def handle_call({:divide, n1, n2}, _from, state) when is_number(n1) and is_number(n2) do
    {:reply, n1 / n2, state}
  end
end
