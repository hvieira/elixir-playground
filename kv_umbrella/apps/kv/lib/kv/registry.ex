defmodule KV.Registry do
  use GenServer

  @impl true
  def init(table_name) do
    names = :ets.new(table_name, [:named_table, read_concurrency: true])
    monitoring_refs = %{}
    {:ok, {names, monitoring_refs}}
  end

  @impl true
  def handle_call({:create, name}, _from, {names, refs} = original_state) do
    case lookup(names, name) do
      {:ok, pid} ->
        {:reply, pid, original_state}
      :error ->
        {:ok, pid} = DynamicSupervisor.start_child(KV.BucketSupervisor, KV.Bucket)
        ref = Process.monitor(pid)
        new_refs = Map.put(refs, ref, name)
        :ets.insert(names, {name, pid})
        {:reply, pid, {names, new_refs}}
    end
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
    {name, refs} = Map.pop(refs, ref)
    :ets.delete(names, name)
    {:noreply, {names, refs}}
  end

  @impl true
  def handle_info(msg, state) do
    require Logger
    Logger.warn("Unexpected message in KV.Registry: #{inspect(msg)}")
    {:noreply, state}
  end

  ## Client API
  @doc """
  Starts the registry with the given options.

  `:name` is always required.
  """
  @spec start_link(list()) :: GenServer.on_start
  def start_link(opts) do
    table_name = Keyword.fetch!(opts, :name)
    GenServer.start_link(__MODULE__, table_name, opts)
  end

  @doc """
  Looks up the bucket pid for `name` stored in `server`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  @spec lookup(pid(), String.t()) :: {:ok, pid()} | :error
  def lookup(server, name) do
    case :ets.lookup(server, name) do
      [{^name, pid}] -> {:ok, pid}
      [] -> :error
    end
  end

  @doc """
  Ensures there is a bucket associated with the given `name` in `server`.
  """
  @spec lookup(pid(), String.t()) :: term
  def create(server, name) do
    GenServer.call(server, {:create, name})
  end

end
