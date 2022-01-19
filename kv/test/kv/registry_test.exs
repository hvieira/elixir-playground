defmodule KV.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    registry = start_supervised!(KV.Registry)
    %{registry: registry}
  end

  test "starts with no registered names", %{registry: registry} do
    assert KV.Registry.lookup(registry, "milk") == :error
    assert KV.Registry.lookup(registry, "bucket") == :error
    assert KV.Registry.lookup(registry, "shopping") == :error
  end

  test "can have named buckets added which can be looked up", %{registry: registry} do
    assert KV.Registry.create(registry, "milk") == :ok

    assert {:ok, bucket} = KV.Registry.lookup(registry, "milk")
    assert is_pid(bucket)

    KV.Bucket.put(bucket, "milk", 1)
    assert KV.Bucket.get(bucket, "milk") == 1
  end

end
