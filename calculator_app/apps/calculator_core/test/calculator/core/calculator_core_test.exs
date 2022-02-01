defmodule CalculatorCoreTest do
  use ExUnit.Case
  doctest Calculator.Core

  @moduletag :capture_log

  test "Supports sum operations - integers" do
    assert Calculator.Core.sum(1, 3) == 4
    assert Calculator.Core.sum(0, 0) == 0
    assert Calculator.Core.sum(0, 1) == 1
    assert Calculator.Core.sum(1, 0) == 1

    assert Calculator.Core.sum(-1, -1) == -2
    assert Calculator.Core.sum(0, -1) == -1
    assert Calculator.Core.sum(-1, 0) == -1
    assert Calculator.Core.sum(3, -7) == -4
  end

  test "Supports sum operations - decimals" do
    assert Calculator.Core.sum(0.0, 0.0) == 0.0
    assert Calculator.Core.sum(0.1, 0.0) == 0.1
    assert Calculator.Core.sum(0.0, 0.1) == 0.1
    assert Calculator.Core.sum(0.1, 1.0) == 1.1
    assert Calculator.Core.sum(3.1, 6.4) == 9.5

    assert Calculator.Core.sum(-0.1, 1.0) == 0.9
  end

  test "Supports minus operations - integers" do
    assert Calculator.Core.minus(7, 3) == 4
    assert Calculator.Core.minus(0, 0) == 0
    assert Calculator.Core.minus(1, 0) == 1

    assert Calculator.Core.minus(-1, -1) == 0
    assert Calculator.Core.minus(0, -1) == 1
    assert Calculator.Core.minus(-1, 0) == -1
    assert Calculator.Core.minus(3, -7) == 10
  end

  test "Supports minus operations - decimals" do
    assert Calculator.Core.minus(0.0, 0.0) == 0.0
    assert Calculator.Core.minus(0.1, 0.0) == 0.1
    assert Calculator.Core.minus(0.0, 0.1) == -0.1
    assert Calculator.Core.minus(0.1, 1.0) == -0.9
    assert Calculator.Core.minus(3.5, 3.0) == 0.5

    assert Calculator.Core.minus(-0.1, 1.0) == -1.1
  end

  test "Keeps agents running - bad messages" do
    send(Calculator.Core.SumAgent, :hack)
    assert Calculator.Core.sum(1, 3) == 4

    send(Calculator.Core.MinusAgent, :hack)
    assert Calculator.Core.minus(1, 3) == -2
  end

  test "Keeps agents running - even when stopped" do
    GenServer.stop(Calculator.Core.SumAgent, :crashed)
    GenServer.stop(Calculator.Core.MinusAgent, :crashed)

    wait_for_process_to_be_alive(Calculator.Core.SumAgent)
    assert Calculator.Core.sum(1, 3) == 4

    wait_for_process_to_be_alive(Calculator.Core.MinusAgent)
    assert Calculator.Core.minus(1, 3) == -2
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

  #    case Process.whereis(name) do
  #      nil ->
  #        wait_for_process_to_be_alive(
  #          name,
  #          time_elapsed + (:os.system_time(:milli_seconds) - start),
  #          timeout
  #        )
  #
  #      pid ->
  #        case {Process.alive?(pid), time_elapsed} do
  #          {true, _elapsed} ->
  #            true
  #
  #          {false, elapsed} when elapsed >= timeout ->
  #            false
  #
  #          _ ->
  #            wait_for_process_to_be_alive(
  #              name,
  #              time_elapsed + (:os.system_time(:milli_seconds) - start),
  #              timeout
  #            )
  #        end
  #
  #    end
  #  end
end
