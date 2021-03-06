defmodule CalculatorCoreTest do
  use ExUnit.Case
  doctest Calculator.Core

  @moduletag :capture_log

  test "Supports sum operations - integers" do
    assert Calculator.Core.add(1, 3) == 4
    assert Calculator.Core.add(0, 0) == 0
    assert Calculator.Core.add(0, 1) == 1
    assert Calculator.Core.add(1, 0) == 1

    assert Calculator.Core.add(-1, -1) == -2
    assert Calculator.Core.add(0, -1) == -1
    assert Calculator.Core.add(-1, 0) == -1
    assert Calculator.Core.add(3, -7) == -4
  end

  test "Supports sum operations - decimals" do
    assert Calculator.Core.add(0.0, 0.0) == 0.0
    assert Calculator.Core.add(0.1, 0.0) == 0.1
    assert Calculator.Core.add(0.0, 0.1) == 0.1
    assert Calculator.Core.add(0.1, 1.0) == 1.1
    assert Calculator.Core.add(3.1, 6.4) == 9.5

    assert Calculator.Core.add(-0.1, 1.0) == 0.9
  end

  test "Supports minus operations - integers" do
    assert Calculator.Core.subtract(7, 3) == 4
    assert Calculator.Core.subtract(0, 0) == 0
    assert Calculator.Core.subtract(1, 0) == 1

    assert Calculator.Core.subtract(-1, -1) == 0
    assert Calculator.Core.subtract(0, -1) == 1
    assert Calculator.Core.subtract(-1, 0) == -1
    assert Calculator.Core.subtract(3, -7) == 10
  end

  test "Supports minus operations - decimals" do
    assert Calculator.Core.subtract(0.0, 0.0) == 0.0
    assert Calculator.Core.subtract(0.1, 0.0) == 0.1
    assert Calculator.Core.subtract(0.0, 0.1) == -0.1
    assert Calculator.Core.subtract(0.1, 1.0) == -0.9
    assert Calculator.Core.subtract(3.5, 3.0) == 0.5

    assert Calculator.Core.subtract(-0.1, 1.0) == -1.1
  end

  test "Supports multiply operations" do
    assert Calculator.Core.multiply(0, 0) == 0
    assert Calculator.Core.multiply(1, 0) == 0
    assert Calculator.Core.multiply(0, 1) == 0
    assert Calculator.Core.multiply(7, 3) == 21
    assert Calculator.Core.multiply(5.5, 2) == 11
    assert Calculator.Core.multiply(6, 2.5) == 15
  end

  test "Supports divide operations" do
    assert Calculator.Core.divide(0, 1) == 0
    assert Calculator.Core.divide(9, 3) == 3
    assert Calculator.Core.divide(7, 3.5) == 2
    assert Calculator.Core.divide(10.5, 2) == 5.25
  end

  test "divide by zero returns error" do
    assert Calculator.Core.divide(0, 0) == :divide_by_zero_error
    assert Calculator.Core.divide(1, 0) == :divide_by_zero_error
  end

  test "interprets and computes add calculations" do
    assert Calculator.Core.calculate("1+1") == {:ok, 2.0}
    assert Calculator.Core.calculate("7.57+3") == {:ok, 10.57}
  end

  test "interprets and computes subtract calculations" do
    assert Calculator.Core.calculate("1-1") == {:ok, 0.0}
    assert Calculator.Core.calculate("7.57-3") == {:ok, 4.57}
  end

  test "interprets and computes multiply calculations" do
    assert Calculator.Core.calculate("1*1") == {:ok, 1.0}
    assert Calculator.Core.calculate("1*2") == {:ok, 2.0}
    assert Calculator.Core.calculate("2*3") == {:ok, 6.0}
    assert Calculator.Core.calculate("7.57*3") == {:ok, 22.71}
    assert Calculator.Core.calculate("7.57*3.3") == {:ok, 24.981}
    assert Calculator.Core.calculate("7.57*3.39") == {:ok, 25.6623}
  end

  test "interprets and computes divide calculations" do
    assert Calculator.Core.calculate("1/1") == {:ok, 1.0}
    assert Calculator.Core.calculate("1/2") == {:ok, 0.5}
    assert Calculator.Core.calculate("2/3") == {:ok, 0.66667}
    assert Calculator.Core.calculate("7.57/3") == {:ok, 2.52333}
    assert Calculator.Core.calculate("7.57/3.3") == {:ok, 2.29394}
    assert Calculator.Core.calculate("7.57/3.39") == {:ok, 2.23304}
  end

  test "Keeps agents running - bad messages" do
    send(Calculator.Core.AddAgent, :hack)
    assert Calculator.Core.add(1, 3) == 4

    send(Calculator.Core.SubtractAgent, :hack)
    assert Calculator.Core.subtract(1, 3) == -2

    send(Calculator.Core.MultiplyAgent, :hack)
    assert Calculator.Core.multiply(1, 3) == 3
  end

  test "Keeps agents running - even when stopped" do
    GenServer.stop(Calculator.Core.AddAgent, :crashed)
    GenServer.stop(Calculator.Core.SubtractAgent, :crashed)
    GenServer.stop(Calculator.Core.MultiplyAgent, :crashed)

    wait_for_process_to_be_alive(Calculator.Core.AddAgent)
    assert Calculator.Core.add(1, 3) == 4

    wait_for_process_to_be_alive(Calculator.Core.SubtractAgent)
    assert Calculator.Core.subtract(1, 3) == -2

    wait_for_process_to_be_alive(Calculator.Core.MultiplyAgent)
    assert Calculator.Core.multiply(1, 3) == 3
  end

  defp wait_for_process_to_be_alive(name, time_elapsed \\ 0, timeout \\ 1000)

  defp wait_for_process_to_be_alive(_name, time_elapsed, timeout) when time_elapsed >= timeout do
    false
  end

  defp wait_for_process_to_be_alive(name, time_elapsed, timeout) do
    start = :os.system_time(:milli_seconds)

    with pid when is_pid(pid) <- Process.whereis(name),
         true <-
           Process.alive?(pid) do
      true
    else
      _ ->
        wait_for_process_to_be_alive(
          name,
          time_elapsed + (:os.system_time(:milli_seconds) - start),
          timeout
        )
    end
  end
end
