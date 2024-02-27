defmodule Minesweeper.GameTest do
  use ExUnit.Case, async: true

  alias Minesweeper.Game
  alias Minesweeper.Cell
  alias Minesweeper.Coordinates

  test "games are created with provided width and height with all cells not revealed" do
    assert Game.create(1, 1, 0) == %Game{
             width: 1,
             height: 1,
             cells: %{
               %Coordinates{x: 0, y: 0} => %Cell{revealed: false}
             }
           }

    assert Game.create(3, 3, 0) == %Game{
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

    assert Game.create(5, 3, 0) == %Game{
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

    assert Game.create(7, 2, 0) == %Game{
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

    assert Game.create(2, 7, 0) == %Game{
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

  test "boards are created with the wanted number of mined cells" do
    assert Game.create(3, 3, 0, fn _cells, _num_mines ->
             [
               {%Coordinates{x: 0, y: 1}, :not_important},
               {%Coordinates{x: 1, y: 2}, :not_important}
             ]
           end) == %Game{
             width: 3,
             height: 3,
             cells: %{
               %Coordinates{x: 0, y: 0} => %Cell{mined: false, num_adjacent_mines: 1},
               %Coordinates{x: 0, y: 1} => %Cell{mined: true, num_adjacent_mines: 1},
               %Coordinates{x: 0, y: 2} => %Cell{mined: false, num_adjacent_mines: 2},
               %Coordinates{x: 1, y: 0} => %Cell{mined: false, num_adjacent_mines: 1},
               %Coordinates{x: 1, y: 1} => %Cell{mined: false, num_adjacent_mines: 2},
               %Coordinates{x: 1, y: 2} => %Cell{mined: true, num_adjacent_mines: 1},
               %Coordinates{x: 2, y: 0} => %Cell{mined: false, num_adjacent_mines: 0},
               %Coordinates{x: 2, y: 1} => %Cell{mined: false, num_adjacent_mines: 1},
               %Coordinates{x: 2, y: 2} => %Cell{mined: false, num_adjacent_mines: 1}
             }
           }

    assert Game.create(3, 3, 0, fn _cells, _num_mines ->
             [
               {%Coordinates{x: 0, y: 0}, :not_important},
               {%Coordinates{x: 1, y: 1}, :not_important},
               {%Coordinates{x: 2, y: 2}, :not_important}
             ]
           end) == %Game{
             width: 3,
             height: 3,
             cells: %{
               %Coordinates{x: 0, y: 0} => %Cell{mined: true, num_adjacent_mines: 1},
               %Coordinates{x: 0, y: 1} => %Cell{mined: false, num_adjacent_mines: 2},
               %Coordinates{x: 0, y: 2} => %Cell{mined: false, num_adjacent_mines: 1},
               %Coordinates{x: 1, y: 0} => %Cell{mined: false, num_adjacent_mines: 2},
               %Coordinates{x: 1, y: 1} => %Cell{mined: true, num_adjacent_mines: 2},
               %Coordinates{x: 1, y: 2} => %Cell{mined: false, num_adjacent_mines: 2},
               %Coordinates{x: 2, y: 0} => %Cell{mined: false, num_adjacent_mines: 1},
               %Coordinates{x: 2, y: 1} => %Cell{mined: false, num_adjacent_mines: 2},
               %Coordinates{x: 2, y: 2} => %Cell{mined: true, num_adjacent_mines: 1}
             }
           }
  end

  test "revealing a non-mined cell with adjacent mines reveals only that cell" do
    game = %Game{
      width: 3,
      height: 3,
      cells: %{
        %Coordinates{x: 0, y: 0} => %Cell{mined: false, num_adjacent_mines: 1},
        %Coordinates{x: 0, y: 1} => %Cell{mined: true, num_adjacent_mines: 1},
        %Coordinates{x: 0, y: 2} => %Cell{mined: false, num_adjacent_mines: 2},
        %Coordinates{x: 1, y: 0} => %Cell{mined: false, num_adjacent_mines: 1},
        %Coordinates{x: 1, y: 1} => %Cell{mined: false, num_adjacent_mines: 2},
        %Coordinates{x: 1, y: 2} => %Cell{mined: true, num_adjacent_mines: 1},
        %Coordinates{x: 2, y: 0} => %Cell{mined: false, num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 1} => %Cell{mined: false, num_adjacent_mines: 1},
        %Coordinates{x: 2, y: 2} => %Cell{mined: false, num_adjacent_mines: 1}
      }
    }

    assert Game.reveal(game, %Coordinates{x: 0, y: 0}) ==
             {:ok,
              %Game{
                width: 3,
                height: 3,
                cells: %{
                  %Coordinates{x: 0, y: 0} => %Cell{
                    revealed: true,
                    mined: false,
                    num_adjacent_mines: 1
                  },
                  %Coordinates{x: 0, y: 1} => %Cell{mined: true, num_adjacent_mines: 1},
                  %Coordinates{x: 0, y: 2} => %Cell{mined: false, num_adjacent_mines: 2},
                  %Coordinates{x: 1, y: 0} => %Cell{mined: false, num_adjacent_mines: 1},
                  %Coordinates{x: 1, y: 1} => %Cell{mined: false, num_adjacent_mines: 2},
                  %Coordinates{x: 1, y: 2} => %Cell{mined: true, num_adjacent_mines: 1},
                  %Coordinates{x: 2, y: 0} => %Cell{mined: false, num_adjacent_mines: 0},
                  %Coordinates{x: 2, y: 1} => %Cell{mined: false, num_adjacent_mines: 1},
                  %Coordinates{x: 2, y: 2} => %Cell{mined: false, num_adjacent_mines: 1}
                }
              }}

    assert Game.reveal(game, %Coordinates{x: 0, y: 2}) ==
             {:ok,
              %Game{
                width: 3,
                height: 3,
                cells: %{
                  %Coordinates{x: 0, y: 0} => %Cell{mined: false, num_adjacent_mines: 1},
                  %Coordinates{x: 0, y: 1} => %Cell{mined: true, num_adjacent_mines: 1},
                  %Coordinates{x: 0, y: 2} => %Cell{
                    revealed: true,
                    mined: false,
                    num_adjacent_mines: 2
                  },
                  %Coordinates{x: 1, y: 0} => %Cell{mined: false, num_adjacent_mines: 1},
                  %Coordinates{x: 1, y: 1} => %Cell{mined: false, num_adjacent_mines: 2},
                  %Coordinates{x: 1, y: 2} => %Cell{mined: true, num_adjacent_mines: 1},
                  %Coordinates{x: 2, y: 0} => %Cell{mined: false, num_adjacent_mines: 0},
                  %Coordinates{x: 2, y: 1} => %Cell{mined: false, num_adjacent_mines: 1},
                  %Coordinates{x: 2, y: 2} => %Cell{mined: false, num_adjacent_mines: 1}
                }
              }}

    assert Game.reveal(game, %Coordinates{x: 2, y: 1}) ==
             {:ok,
              %Game{
                width: 3,
                height: 3,
                cells: %{
                  %Coordinates{x: 0, y: 0} => %Cell{mined: false, num_adjacent_mines: 1},
                  %Coordinates{x: 0, y: 1} => %Cell{mined: true, num_adjacent_mines: 1},
                  %Coordinates{x: 0, y: 2} => %Cell{mined: false, num_adjacent_mines: 2},
                  %Coordinates{x: 1, y: 0} => %Cell{mined: false, num_adjacent_mines: 1},
                  %Coordinates{x: 1, y: 1} => %Cell{mined: false, num_adjacent_mines: 2},
                  %Coordinates{x: 1, y: 2} => %Cell{mined: true, num_adjacent_mines: 1},
                  %Coordinates{x: 2, y: 0} => %Cell{mined: false, num_adjacent_mines: 0},
                  %Coordinates{x: 2, y: 1} => %Cell{
                    revealed: true,
                    mined: false,
                    num_adjacent_mines: 1
                  },
                  %Coordinates{x: 2, y: 2} => %Cell{mined: false, num_adjacent_mines: 1}
                }
              }}
  end

  test "revealing a revealed cell is a no-op" do
    game = %Game{
      width: 3,
      height: 3,
      cells: %{
        %Coordinates{x: 0, y: 0} => %Cell{mined: false, num_adjacent_mines: 1},
        %Coordinates{x: 0, y: 1} => %Cell{mined: true, num_adjacent_mines: 1},
        %Coordinates{x: 0, y: 2} => %Cell{mined: false, num_adjacent_mines: 2},
        %Coordinates{x: 1, y: 0} => %Cell{mined: false, num_adjacent_mines: 1},
        %Coordinates{x: 1, y: 1} => %Cell{mined: false, num_adjacent_mines: 2},
        %Coordinates{x: 1, y: 2} => %Cell{mined: true, num_adjacent_mines: 1},
        %Coordinates{x: 2, y: 0} => %Cell{mined: false, num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 1} => %Cell{
          revealed: true,
          mined: false,
          num_adjacent_mines: 1
        },
        %Coordinates{x: 2, y: 2} => %Cell{mined: false, num_adjacent_mines: 1}
      }
    }

    assert Game.reveal(game, %Coordinates{x: 2, y: 1}) == {:ok, game}
  end

  test "revealing a cell with invalid coordinates is an error" do
    game = %Game{
      width: 3,
      height: 3,
      cells: %{
        %Coordinates{x: 0, y: 0} => %Cell{mined: false, num_adjacent_mines: 1},
        %Coordinates{x: 0, y: 1} => %Cell{mined: true, num_adjacent_mines: 1},
        %Coordinates{x: 0, y: 2} => %Cell{mined: false, num_adjacent_mines: 2},
        %Coordinates{x: 1, y: 0} => %Cell{mined: false, num_adjacent_mines: 1},
        %Coordinates{x: 1, y: 1} => %Cell{mined: false, num_adjacent_mines: 2},
        %Coordinates{x: 1, y: 2} => %Cell{mined: true, num_adjacent_mines: 1},
        %Coordinates{x: 2, y: 0} => %Cell{mined: false, num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 1} => %Cell{mined: false, num_adjacent_mines: 1},
        %Coordinates{x: 2, y: 2} => %Cell{mined: false, num_adjacent_mines: 1}
      }
    }

    assert Game.reveal(game, %Coordinates{x: 0, y: 3}) == {:invalid_coordinates, game}
    assert Game.reveal(game, %Coordinates{x: 3, y: 0}) == {:invalid_coordinates, game}
    assert Game.reveal(game, %Coordinates{x: 3, y: 3}) == {:invalid_coordinates, game}
    assert Game.reveal(game, %Coordinates{x: 7, y: 3}) == {:invalid_coordinates, game}
    assert Game.reveal(game, %Coordinates{x: 3, y: 7}) == {:invalid_coordinates, game}
    assert Game.reveal(game, %Coordinates{x: 7, y: 7}) == {:invalid_coordinates, game}
  end

  test "revealing a mined cell is game over" do
    game = %Game{
      width: 3,
      height: 3,
      cells: %{
        %Coordinates{x: 0, y: 0} => %Cell{mined: false, num_adjacent_mines: 1},
        %Coordinates{x: 0, y: 1} => %Cell{mined: true, num_adjacent_mines: 1},
        %Coordinates{x: 0, y: 2} => %Cell{mined: false, num_adjacent_mines: 2},
        %Coordinates{x: 1, y: 0} => %Cell{mined: false, num_adjacent_mines: 1},
        %Coordinates{x: 1, y: 1} => %Cell{mined: false, num_adjacent_mines: 2},
        %Coordinates{x: 1, y: 2} => %Cell{mined: true, num_adjacent_mines: 1},
        %Coordinates{x: 2, y: 0} => %Cell{mined: false, num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 1} => %Cell{mined: false, num_adjacent_mines: 1},
        %Coordinates{x: 2, y: 2} => %Cell{mined: false, num_adjacent_mines: 1}
      }
    }

    assert Game.reveal(game, %Coordinates{x: 1, y: 2}) ==
             {:lost,
              %Game{
                width: 3,
                height: 3,
                cells: %{
                  %Coordinates{x: 0, y: 0} => %Cell{mined: false, num_adjacent_mines: 1},
                  %Coordinates{x: 0, y: 1} => %Cell{mined: true, num_adjacent_mines: 1},
                  %Coordinates{x: 0, y: 2} => %Cell{mined: false, num_adjacent_mines: 2},
                  %Coordinates{x: 1, y: 0} => %Cell{mined: false, num_adjacent_mines: 1},
                  %Coordinates{x: 1, y: 1} => %Cell{mined: false, num_adjacent_mines: 2},
                  %Coordinates{x: 1, y: 2} => %Cell{
                    revealed: true,
                    mined: true,
                    num_adjacent_mines: 1
                  },
                  %Coordinates{x: 2, y: 0} => %Cell{mined: false, num_adjacent_mines: 0},
                  %Coordinates{x: 2, y: 1} => %Cell{mined: false, num_adjacent_mines: 1},
                  %Coordinates{x: 2, y: 2} => %Cell{mined: false, num_adjacent_mines: 1}
                }
              }}
  end

  test "revealing a safe (not mined & no adjacent mines) cell reveals that cell and all other safe cells recursively - scenario with only 1 cell" do
    game = %Game{
      width: 3,
      height: 3,
      cells: %{
        %Coordinates{x: 0, y: 0} => %Cell{num_adjacent_mines: 1},
        %Coordinates{x: 0, y: 1} => %Cell{mined: true, num_adjacent_mines: 1},
        %Coordinates{x: 0, y: 2} => %Cell{num_adjacent_mines: 2},
        %Coordinates{x: 1, y: 0} => %Cell{num_adjacent_mines: 1},
        %Coordinates{x: 1, y: 1} => %Cell{num_adjacent_mines: 2},
        %Coordinates{x: 1, y: 2} => %Cell{mined: true, num_adjacent_mines: 1},
        %Coordinates{x: 2, y: 0} => %Cell{num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 1} => %Cell{num_adjacent_mines: 1},
        %Coordinates{x: 2, y: 2} => %Cell{num_adjacent_mines: 1}
      }
    }

    assert Game.reveal(game, %Coordinates{x: 2, y: 0}) ==
             {:ok,
              %Game{
                width: 3,
                height: 3,
                cells: %{
                  %Coordinates{x: 0, y: 0} => %Cell{num_adjacent_mines: 1},
                  %Coordinates{x: 0, y: 1} => %Cell{mined: true, num_adjacent_mines: 1},
                  %Coordinates{x: 0, y: 2} => %Cell{num_adjacent_mines: 2},
                  %Coordinates{x: 1, y: 0} => %Cell{num_adjacent_mines: 1},
                  %Coordinates{x: 1, y: 1} => %Cell{num_adjacent_mines: 2},
                  %Coordinates{x: 1, y: 2} => %Cell{mined: true, num_adjacent_mines: 1},
                  %Coordinates{x: 2, y: 0} => %Cell{
                    revealed: true,
                    mined: false,
                    num_adjacent_mines: 0
                  },
                  %Coordinates{x: 2, y: 1} => %Cell{num_adjacent_mines: 1},
                  %Coordinates{x: 2, y: 2} => %Cell{num_adjacent_mines: 1}
                }
              }}
  end

  test "revealing a safe (not mined & no adjacent mines) cell reveals that cell and all other safe cells recursively - scenario with more cells" do
    initial_game = %Game{
      width: 3,
      height: 3,
      cells: %{
        %Coordinates{x: 0, y: 0} => %Cell{mined: true, num_adjacent_mines: 0},
        %Coordinates{x: 0, y: 1} => %Cell{num_adjacent_mines: 1},
        %Coordinates{x: 0, y: 2} => %Cell{num_adjacent_mines: 0},
        %Coordinates{x: 1, y: 0} => %Cell{num_adjacent_mines: 1},
        %Coordinates{x: 1, y: 1} => %Cell{num_adjacent_mines: 1},
        %Coordinates{x: 1, y: 2} => %Cell{num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 0} => %Cell{num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 1} => %Cell{num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 2} => %Cell{num_adjacent_mines: 0}
      }
    }

    all_safe_cells_revealed = %Game{
      width: 3,
      height: 3,
      cells: %{
        %Coordinates{x: 0, y: 0} => %Cell{mined: true, num_adjacent_mines: 0},
        %Coordinates{x: 0, y: 1} => %Cell{num_adjacent_mines: 1},
        %Coordinates{x: 0, y: 2} => %Cell{revealed: true, num_adjacent_mines: 0},
        %Coordinates{x: 1, y: 0} => %Cell{num_adjacent_mines: 1},
        %Coordinates{x: 1, y: 1} => %Cell{num_adjacent_mines: 1},
        %Coordinates{x: 1, y: 2} => %Cell{revealed: true, num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 0} => %Cell{revealed: true, num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 1} => %Cell{revealed: true, num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 2} => %Cell{revealed: true, num_adjacent_mines: 0}
      }
    }

    assert Game.reveal(initial_game, %Coordinates{x: 0, y: 2}) == {:ok, all_safe_cells_revealed}
    assert Game.reveal(initial_game, %Coordinates{x: 1, y: 2}) == {:ok, all_safe_cells_revealed}
    assert Game.reveal(initial_game, %Coordinates{x: 2, y: 0}) == {:ok, all_safe_cells_revealed}
    assert Game.reveal(initial_game, %Coordinates{x: 2, y: 1}) == {:ok, all_safe_cells_revealed}
    assert Game.reveal(initial_game, %Coordinates{x: 2, y: 2}) == {:ok, all_safe_cells_revealed}
  end
end
