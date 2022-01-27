defmodule KV.RegistryTest do
  use ExUnit.Case, async: true

  setup context do
    start_supervised!({KV.Registry, name: context.test})
    %{registry: context.test}
  end

  test "starts with no registered names", %{registry: registry} do
    assert KV.Registry.lookup(registry, "milk") == :error
    assert KV.Registry.lookup(registry, "bucket") == :error
    assert KV.Registry.lookup(registry, "shopping") == :error
  end

  test "can have named buckets added which can be looked up", %{registry: registry} do
    assert KV.Registry.create(registry, "milk")
    assert KV.Registry.create(registry, "eggs")

    assert {:ok, bucket} = KV.Registry.lookup(registry, "milk")
    assert is_pid(bucket)
    KV.Bucket.put(bucket, "milk", 1)
    assert KV.Bucket.get(bucket, "milk") == 1

    assert {:ok, bucket} = KV.Registry.lookup(registry, "eggs")
    assert is_pid(bucket)
    KV.Bucket.put(bucket, "eggs", 3)
    assert KV.Bucket.get(bucket, "eggs") == 3
  end

  test "removes buckets on exit", %{registry: registry} do
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

    # Stop the bucket
    Agent.stop(bucket)

    # Do a call to ensure the registry processed the previous DOWN message
    _ = KV.Registry.create(registry, "bogus")

    assert KV.Registry.lookup(registry, "shopping") == :error
  end

  test "removes bucket on crash", %{registry: registry} do
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

    # Stop the bucket with non-normal reason
    Agent.stop(bucket, :shutdown)

    # Do a call to ensure the registry processed the previous DOWN message
    _ = KV.Registry.create(registry, "bogus")

    assert KV.Registry.lookup(registry, "shopping") == :error
  end

  test "bucket can crash at any time", %{registry: registry} do
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

    # Simulate a bucket crash by explicitly and synchronously shutting it down
    Agent.stop(bucket, :shutdown)

    # Now trying to call the dead process causes a :noproc exit
    catch_exit KV.Bucket.put(bucket, "milk", 3)
  end

end
