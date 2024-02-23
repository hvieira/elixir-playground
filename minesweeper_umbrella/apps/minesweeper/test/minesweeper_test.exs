defmodule Minesweeper.GameTest do
  use ExUnit.Case, async: true

  alias Minesweeper.Game
  alias Minesweeper.Cell
  alias Minesweeper.Coordinates

  test "games are created with provided width and height with all cells not revealed" do
    assert Game.create(1, 1) == %Game{
             width: 1,
             height: 1,
             cells: %{
               %Coordinates{x: 0, y: 0} => %Cell{revealed: false}
             }
           }

    assert Game.create(3, 3) == %Game{
             width: 3,
             height: 3,
             cells: %{
               %Coordinates{x: 0, y: 0} => %Cell{revealed: false},
               %Coordinates{x: 0, y: 1} => %Cell{revealed: false},
               %Coordinates{x: 0, y: 2} => %Cell{revealed: false},
               %Coordinates{x: 1, y: 0} => %Cell{revealed: false},
               %Coordinates{x: 1, y: 1} => %Cell{revealed: false},
               %Coordinates{x: 1, y: 2} => %Cell{revealed: false},
               %Coordinates{x: 2, y: 0} => %Cell{revealed: false},
               %Coordinates{x: 2, y: 1} => %Cell{revealed: false},
               %Coordinates{x: 2, y: 2} => %Cell{revealed: false}
             }
           }

    assert Game.create(5, 3) == %Game{
             width: 5,
             height: 3,
             cells: %{
               %Coordinates{x: 0, y: 0} => %Cell{revealed: false},
               %Coordinates{x: 0, y: 1} => %Cell{revealed: false},
               %Coordinates{x: 0, y: 2} => %Cell{revealed: false},
               %Coordinates{x: 0, y: 3} => %Cell{revealed: false},
               %Coordinates{x: 0, y: 4} => %Cell{revealed: false},
               %Coordinates{x: 1, y: 0} => %Cell{revealed: false},
               %Coordinates{x: 1, y: 1} => %Cell{revealed: false},
               %Coordinates{x: 1, y: 2} => %Cell{revealed: false},
               %Coordinates{x: 1, y: 3} => %Cell{revealed: false},
               %Coordinates{x: 1, y: 4} => %Cell{revealed: false},
               %Coordinates{x: 2, y: 0} => %Cell{revealed: false},
               %Coordinates{x: 2, y: 1} => %Cell{revealed: false},
               %Coordinates{x: 2, y: 2} => %Cell{revealed: false},
               %Coordinates{x: 2, y: 3} => %Cell{revealed: false},
               %Coordinates{x: 2, y: 4} => %Cell{revealed: false}
             }
           }

    assert Game.create(7, 2) == %Game{
             width: 7,
             height: 2,
             cells: %{
               %Coordinates{x: 0, y: 0} => %Cell{revealed: false},
               %Coordinates{x: 0, y: 1} => %Cell{revealed: false},
               %Coordinates{x: 0, y: 2} => %Cell{revealed: false},
               %Coordinates{x: 0, y: 3} => %Cell{revealed: false},
               %Coordinates{x: 0, y: 4} => %Cell{revealed: false},
               %Coordinates{x: 0, y: 5} => %Cell{revealed: false},
               %Coordinates{x: 0, y: 6} => %Cell{revealed: false},
               %Coordinates{x: 1, y: 0} => %Cell{revealed: false},
               %Coordinates{x: 1, y: 1} => %Cell{revealed: false},
               %Coordinates{x: 1, y: 2} => %Cell{revealed: false},
               %Coordinates{x: 1, y: 3} => %Cell{revealed: false},
               %Coordinates{x: 1, y: 4} => %Cell{revealed: false},
               %Coordinates{x: 1, y: 5} => %Cell{revealed: false},
               %Coordinates{x: 1, y: 6} => %Cell{revealed: false}
             }
           }

    assert Game.create(2, 7) == %Game{
             width: 2,
             height: 7,
             cells: %{
               %Coordinates{x: 0, y: 0} => %Cell{revealed: false},
               %Coordinates{x: 0, y: 1} => %Cell{revealed: false},
               %Coordinates{x: 1, y: 0} => %Cell{revealed: false},
               %Coordinates{x: 1, y: 1} => %Cell{revealed: false},
               %Coordinates{x: 2, y: 0} => %Cell{revealed: false},
               %Coordinates{x: 2, y: 1} => %Cell{revealed: false},
               %Coordinates{x: 3, y: 0} => %Cell{revealed: false},
               %Coordinates{x: 3, y: 1} => %Cell{revealed: false},
               %Coordinates{x: 4, y: 0} => %Cell{revealed: false},
               %Coordinates{x: 4, y: 1} => %Cell{revealed: false},
               %Coordinates{x: 5, y: 0} => %Cell{revealed: false},
               %Coordinates{x: 5, y: 1} => %Cell{revealed: false},
               %Coordinates{x: 6, y: 0} => %Cell{revealed: false},
               %Coordinates{x: 6, y: 1} => %Cell{revealed: false}
             }
           }
  end
end
