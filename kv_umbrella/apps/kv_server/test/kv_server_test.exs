defmodule KVServerTest do
  use ExUnit.Case, async: false

  @moduletag :capture_log

  setup do
    Application.stop(:kv)
    :ok = Application.start(:kv)
  end

  setup do
    opts = [:binary, packet: :line, active: false]
    {:ok, socket} = :gen_tcp.connect('localhost', 4040, opts)
    %{socket: socket}
  end

  test "Unknown commands are replied appropriately", %{socket: socket} do
    assert send_and_recv(socket, "UNKNOWN shopping\r\n") == "UNKNOWN COMMAND\r\n"

    assert send_and_recv(socket, "CRAZY shopping\r\n") == "UNKNOWN COMMAND\r\n"

    assert send_and_recv(socket, "HACK shopping\r\n") == "UNKNOWN COMMAND\r\n"

    assert send_and_recv(socket, "ACCESS shopping\r\n") == "UNKNOWN COMMAND\r\n"
  end

  test "Accessing non-existing buckets return not found", %{socket: socket} do
    assert send_and_recv(socket, "GET shopping bananas\r\n") == "NOT FOUND\r\n"
    assert send_and_recv(socket, "DELETE shopping bananas\r\n") == "NOT FOUND\r\n"
  end

  test "Create buckets", %{socket: socket} do
    assert send_and_recv(socket, "CREATE shopping\r\n") == "OK\r\n"
    assert send_and_recv(socket, "CREATE cinema\r\n") == "OK\r\n"
  end

  test "Add key value pairs to buckets", %{socket: socket} do
    assert send_and_recv(socket, "CREATE shopping\r\n") == "OK\r\n"
    assert send_and_recv(socket, "PUT shopping eggs 12\r\n") == "OK\r\n"
    assert send_and_recv(socket, "PUT shopping milk 1\r\n") == "OK\r\n"
    assert send_and_recv(socket, "PUT shopping meat 1\r\n") == "OK\r\n"
  end

  test "Delete buckets keys", %{socket: socket} do
    assert send_and_recv(socket, "CREATE shopping\r\n") == "OK\r\n"
    assert send_and_recv(socket, "PUT shopping eggs 12\r\n") == "OK\r\n"

    assert send_and_recv(socket, "DELETE shopping eggs\r\n") == "OK\r\n"
    # This should be working this way or give a nil or something else
    # assert send_and_recv(socket, "GET shopping eggs\r\n") == "NOT FOUND\r\n"
    # Instead this is the behaviour from the tutorial
    assert send_and_recv(socket, "GET shopping eggs\r\n") == "\r\n"
  end

  defp send_and_recv(socket, command) do
    :ok = :gen_tcp.send(socket, command)
    {:ok, data} = :gen_tcp.recv(socket, 0, 1000)
    data
  end

end
