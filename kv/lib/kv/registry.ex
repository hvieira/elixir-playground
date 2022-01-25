defmodule KV.Registry do
  use GenServer

  @impl true
  def init(:ok) do
    names = %{}
    monitoring_refs = %{}
    {:ok, {names, monitoring_refs}}
  end

  @impl true
  def handle_call({:lookup, name}, _from, {names, _} = state) do
    {:reply, Map.fetch(names, name), state}
  end

  @impl true
  def handle_cast({:create, name}, {names, refs} = original_state) do
    if Map.has_key?(names, name) do
      {:noreply, original_state}
    else
      {:ok, bucket} = KV.Bucket.start_link([])

      new_bucket_monitor_ref = Process.monitor(bucket)
      new_refs = Map.put(refs, new_bucket_monitor_ref, name)
      new_names = Map.put(names, name, bucket)

      {:noreply, {new_names, new_refs}}
    end
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
    {name, new_refs} = Map.pop(refs, ref)
    new_names = Map.delete(names, name)
    {:noreply, {new_names, new_refs}}
  end

  @impl true
  def handle_info(msg, state) do
    require Logger
    Logger.warn("Unexpected message in KV.Registry: #{inspect(msg)}")
    {:noreply, state}
  end

  ## Client API
  @doc """
  Starts the registry.
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Looks up the bucket pid for `name` stored in `server`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end

  @doc """
  Ensures there is a bucket associated with the given `name` in `server`.
  """
  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end

end
