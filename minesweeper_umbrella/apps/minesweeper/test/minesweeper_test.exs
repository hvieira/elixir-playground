defmodule Minesweeper.GameTest do
  use ExUnit.Case, async: true

  alias Minesweeper.Game
  alias Minesweeper.Cell
  alias Minesweeper.Coordinates

  test "games are created with provided width and height with all cells not revealed" do
    assert Game.create(1, 1, 0) == %Game{
             state: :ongoing,
             width: 1,
             height: 1,
             number_of_mines: 0,
             cells: %{
               %Coordinates{x: 0, y: 0} => %Cell{revealed: false}
             }
           }

    assert Game.create(3, 3, 0) == %Game{
             state: :ongoing,
             width: 3,
             height: 3,
             number_of_mines: 0,
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
             state: :ongoing,
             width: 5,
             height: 3,
             number_of_mines: 0,
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
             state: :ongoing,
             width: 7,
             height: 2,
             number_of_mines: 0,
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
             state: :ongoing,
             width: 2,
             height: 7,
             number_of_mines: 0,
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
    assert Game.create(3, 3, 2, fn _cells, _num_mines ->
             [
               {%Coordinates{x: 0, y: 1}, :not_important},
               {%Coordinates{x: 1, y: 2}, :not_important}
             ]
           end) == %Game{
             state: :ongoing,
             width: 3,
             height: 3,
             number_of_mines: 2,
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

    assert Game.create(3, 3, 3, fn _cells, _num_mines ->
             [
               {%Coordinates{x: 0, y: 0}, :not_important},
               {%Coordinates{x: 1, y: 1}, :not_important},
               {%Coordinates{x: 2, y: 2}, :not_important}
             ]
           end) == %Game{
             state: :ongoing,
             width: 3,
             height: 3,
             number_of_mines: 3,
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
      state: :ongoing,
      width: 3,
      height: 3,
      number_of_mines: 2,
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
                state: :ongoing,
                width: 3,
                height: 3,
                number_of_mines: 2,
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
                state: :ongoing,
                width: 3,
                height: 3,
                number_of_mines: 2,
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
                state: :ongoing,
                width: 3,
                height: 3,
                number_of_mines: 2,
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
      state: :ongoing,
      width: 3,
      height: 3,
      number_of_mines: 2,
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
      state: :ongoing,
      width: 3,
      height: 3,
      number_of_mines: 2,
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
      state: :ongoing,
      width: 3,
      height: 3,
      number_of_mines: 2,
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
             {:ok,
              %Game{
                number_of_mines: 2,
                state: :game_lost,
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
      state: :ongoing,
      width: 3,
      height: 3,
      number_of_mines: 2,
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
                state: :ongoing,
                width: 3,
                height: 3,
                number_of_mines: 2,
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
      state: :ongoing,
      width: 3,
      height: 3,
      number_of_mines: 1,
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
      state: :ongoing,
      width: 3,
      height: 3,
      number_of_mines: 1,
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

  test "flagging a non revealed cell flags that cell" do
    initial_game = %Game{
      state: :ongoing,
      width: 3,
      height: 3,
      number_of_mines: 1,
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

    assert Game.flag(initial_game, %Coordinates{x: 0, y: 0}) ==
             {:ok,
              %Game{
                state: :ongoing,
                width: 3,
                height: 3,
                number_of_mines: 1,
                cells: %{
                  %Coordinates{x: 0, y: 0} => %Cell{
                    mined: true,
                    flagged: true,
                    num_adjacent_mines: 0
                  },
                  %Coordinates{x: 0, y: 1} => %Cell{num_adjacent_mines: 1},
                  %Coordinates{x: 0, y: 2} => %Cell{num_adjacent_mines: 0},
                  %Coordinates{x: 1, y: 0} => %Cell{num_adjacent_mines: 1},
                  %Coordinates{x: 1, y: 1} => %Cell{num_adjacent_mines: 1},
                  %Coordinates{x: 1, y: 2} => %Cell{num_adjacent_mines: 0},
                  %Coordinates{x: 2, y: 0} => %Cell{num_adjacent_mines: 0},
                  %Coordinates{x: 2, y: 1} => %Cell{num_adjacent_mines: 0},
                  %Coordinates{x: 2, y: 2} => %Cell{num_adjacent_mines: 0}
                }
              }}

    assert Game.flag(initial_game, %Coordinates{x: 0, y: 1}) ==
             {:ok,
              %Game{
                state: :ongoing,
                width: 3,
                height: 3,
                number_of_mines: 1,
                cells: %{
                  %Coordinates{x: 0, y: 0} => %Cell{mined: true, num_adjacent_mines: 0},
                  %Coordinates{x: 0, y: 1} => %Cell{flagged: true, num_adjacent_mines: 1},
                  %Coordinates{x: 0, y: 2} => %Cell{num_adjacent_mines: 0},
                  %Coordinates{x: 1, y: 0} => %Cell{num_adjacent_mines: 1},
                  %Coordinates{x: 1, y: 1} => %Cell{num_adjacent_mines: 1},
                  %Coordinates{x: 1, y: 2} => %Cell{num_adjacent_mines: 0},
                  %Coordinates{x: 2, y: 0} => %Cell{num_adjacent_mines: 0},
                  %Coordinates{x: 2, y: 1} => %Cell{num_adjacent_mines: 0},
                  %Coordinates{x: 2, y: 2} => %Cell{num_adjacent_mines: 0}
                }
              }}

    assert Game.flag(initial_game, %Coordinates{x: 2, y: 2}) ==
             {:ok,
              %Game{
                state: :ongoing,
                width: 3,
                height: 3,
                number_of_mines: 1,
                cells: %{
                  %Coordinates{x: 0, y: 0} => %Cell{mined: true, num_adjacent_mines: 0},
                  %Coordinates{x: 0, y: 1} => %Cell{num_adjacent_mines: 1},
                  %Coordinates{x: 0, y: 2} => %Cell{num_adjacent_mines: 0},
                  %Coordinates{x: 1, y: 0} => %Cell{num_adjacent_mines: 1},
                  %Coordinates{x: 1, y: 1} => %Cell{num_adjacent_mines: 1},
                  %Coordinates{x: 1, y: 2} => %Cell{num_adjacent_mines: 0},
                  %Coordinates{x: 2, y: 0} => %Cell{num_adjacent_mines: 0},
                  %Coordinates{x: 2, y: 1} => %Cell{num_adjacent_mines: 0},
                  %Coordinates{x: 2, y: 2} => %Cell{flagged: true, num_adjacent_mines: 0}
                }
              }}
  end

  test "flagging a revealed cell is not supported" do
    initial_game = %Game{
      state: :ongoing,
      width: 3,
      height: 3,
      number_of_mines: 1,
      cells: %{
        %Coordinates{x: 0, y: 0} => %Cell{mined: true, num_adjacent_mines: 0},
        %Coordinates{x: 0, y: 1} => %Cell{revealed: true, flagged: false, num_adjacent_mines: 1},
        %Coordinates{x: 0, y: 2} => %Cell{num_adjacent_mines: 0},
        %Coordinates{x: 1, y: 0} => %Cell{num_adjacent_mines: 1},
        %Coordinates{x: 1, y: 1} => %Cell{num_adjacent_mines: 1},
        %Coordinates{x: 1, y: 2} => %Cell{num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 0} => %Cell{num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 1} => %Cell{num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 2} => %Cell{num_adjacent_mines: 0}
      }
    }

    assert Game.flag(initial_game, %Coordinates{x: 0, y: 1}) ==
             {:invalid_instruction, initial_game}
  end

  test "flagging a flagged cell flagsis a no-op" do
    initial_game = %Game{
      state: :ongoing,
      width: 3,
      height: 3,
      number_of_mines: 1,
      cells: %{
        %Coordinates{x: 0, y: 0} => %Cell{mined: true, flagged: true, num_adjacent_mines: 0},
        %Coordinates{x: 0, y: 1} => %Cell{flagged: true, num_adjacent_mines: 1},
        %Coordinates{x: 0, y: 2} => %Cell{num_adjacent_mines: 0},
        %Coordinates{x: 1, y: 0} => %Cell{num_adjacent_mines: 1},
        %Coordinates{x: 1, y: 1} => %Cell{num_adjacent_mines: 1},
        %Coordinates{x: 1, y: 2} => %Cell{num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 0} => %Cell{num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 1} => %Cell{flagged: true, num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 2} => %Cell{num_adjacent_mines: 0}
      }
    }

    assert Game.flag(initial_game, %Coordinates{x: 0, y: 0}) == {:ok, initial_game}
    assert Game.flag(initial_game, %Coordinates{x: 0, y: 1}) == {:ok, initial_game}
    assert Game.flag(initial_game, %Coordinates{x: 2, y: 1}) == {:ok, initial_game}
  end

  test "flagging a non-existing cell (aka bad coordinates) returns an error" do
    initial_game = %Game{
      state: :ongoing,
      width: 3,
      height: 3,
      number_of_mines: 0,
      cells: %{
        %Coordinates{x: 0, y: 0} => %Cell{},
        %Coordinates{x: 0, y: 1} => %Cell{},
        %Coordinates{x: 0, y: 2} => %Cell{},
        %Coordinates{x: 1, y: 0} => %Cell{},
        %Coordinates{x: 1, y: 1} => %Cell{},
        %Coordinates{x: 1, y: 2} => %Cell{},
        %Coordinates{x: 2, y: 0} => %Cell{},
        %Coordinates{x: 2, y: 1} => %Cell{},
        %Coordinates{x: 2, y: 2} => %Cell{}
      }
    }

    assert Game.flag(initial_game, %Coordinates{x: 0, y: 3}) ==
             {:invalid_coordinates, initial_game}

    assert Game.flag(initial_game, %Coordinates{x: 3, y: 0}) ==
             {:invalid_coordinates, initial_game}

    assert Game.flag(initial_game, %Coordinates{x: 3, y: 3}) ==
             {:invalid_coordinates, initial_game}
  end

  test "unflagging a flagged cell unflags that cell" do
    initial_game = %Game{
      state: :ongoing,
      width: 3,
      height: 3,
      number_of_mines: 1,
      cells: %{
        %Coordinates{x: 0, y: 0} => %Cell{mined: true, flagged: true, num_adjacent_mines: 0},
        %Coordinates{x: 0, y: 1} => %Cell{flagged: true, num_adjacent_mines: 1},
        %Coordinates{x: 0, y: 2} => %Cell{num_adjacent_mines: 0},
        %Coordinates{x: 1, y: 0} => %Cell{num_adjacent_mines: 1},
        %Coordinates{x: 1, y: 1} => %Cell{num_adjacent_mines: 1},
        %Coordinates{x: 1, y: 2} => %Cell{num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 0} => %Cell{num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 1} => %Cell{num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 2} => %Cell{flagged: true, num_adjacent_mines: 0}
      }
    }

    assert Game.unflag(initial_game, %Coordinates{x: 0, y: 0}) ==
             {:ok,
              %Game{
                state: :ongoing,
                width: 3,
                height: 3,
                number_of_mines: 1,
                cells: %{
                  %Coordinates{x: 0, y: 0} => %Cell{
                    mined: true,
                    flagged: false,
                    num_adjacent_mines: 0
                  },
                  %Coordinates{x: 0, y: 1} => %Cell{flagged: true, num_adjacent_mines: 1},
                  %Coordinates{x: 0, y: 2} => %Cell{num_adjacent_mines: 0},
                  %Coordinates{x: 1, y: 0} => %Cell{num_adjacent_mines: 1},
                  %Coordinates{x: 1, y: 1} => %Cell{num_adjacent_mines: 1},
                  %Coordinates{x: 1, y: 2} => %Cell{num_adjacent_mines: 0},
                  %Coordinates{x: 2, y: 0} => %Cell{num_adjacent_mines: 0},
                  %Coordinates{x: 2, y: 1} => %Cell{num_adjacent_mines: 0},
                  %Coordinates{x: 2, y: 2} => %Cell{flagged: true, num_adjacent_mines: 0}
                }
              }}

    assert Game.unflag(initial_game, %Coordinates{x: 0, y: 1}) ==
             {:ok,
              %Game{
                state: :ongoing,
                width: 3,
                height: 3,
                number_of_mines: 1,
                cells: %{
                  %Coordinates{x: 0, y: 0} => %Cell{
                    mined: true,
                    flagged: true,
                    num_adjacent_mines: 0
                  },
                  %Coordinates{x: 0, y: 1} => %Cell{flagged: false, num_adjacent_mines: 1},
                  %Coordinates{x: 0, y: 2} => %Cell{num_adjacent_mines: 0},
                  %Coordinates{x: 1, y: 0} => %Cell{num_adjacent_mines: 1},
                  %Coordinates{x: 1, y: 1} => %Cell{num_adjacent_mines: 1},
                  %Coordinates{x: 1, y: 2} => %Cell{num_adjacent_mines: 0},
                  %Coordinates{x: 2, y: 0} => %Cell{num_adjacent_mines: 0},
                  %Coordinates{x: 2, y: 1} => %Cell{num_adjacent_mines: 0},
                  %Coordinates{x: 2, y: 2} => %Cell{flagged: true, num_adjacent_mines: 0}
                }
              }}

    assert Game.unflag(initial_game, %Coordinates{x: 2, y: 2}) ==
             {:ok,
              %Game{
                state: :ongoing,
                width: 3,
                height: 3,
                number_of_mines: 1,
                cells: %{
                  %Coordinates{x: 0, y: 0} => %Cell{
                    mined: true,
                    flagged: true,
                    num_adjacent_mines: 0
                  },
                  %Coordinates{x: 0, y: 1} => %Cell{flagged: true, num_adjacent_mines: 1},
                  %Coordinates{x: 0, y: 2} => %Cell{num_adjacent_mines: 0},
                  %Coordinates{x: 1, y: 0} => %Cell{num_adjacent_mines: 1},
                  %Coordinates{x: 1, y: 1} => %Cell{num_adjacent_mines: 1},
                  %Coordinates{x: 1, y: 2} => %Cell{num_adjacent_mines: 0},
                  %Coordinates{x: 2, y: 0} => %Cell{num_adjacent_mines: 0},
                  %Coordinates{x: 2, y: 1} => %Cell{num_adjacent_mines: 0},
                  %Coordinates{x: 2, y: 2} => %Cell{flagged: false, num_adjacent_mines: 0}
                }
              }}
  end

  test "unflagging a revealed cell is not supported" do
    initial_game = %Game{
      state: :ongoing,
      width: 3,
      height: 3,
      number_of_mines: 1,
      cells: %{
        %Coordinates{x: 0, y: 0} => %Cell{mined: true, num_adjacent_mines: 0},
        %Coordinates{x: 0, y: 1} => %Cell{revealed: true, flagged: true, num_adjacent_mines: 1},
        %Coordinates{x: 0, y: 2} => %Cell{num_adjacent_mines: 0},
        %Coordinates{x: 1, y: 0} => %Cell{num_adjacent_mines: 1},
        %Coordinates{x: 1, y: 1} => %Cell{num_adjacent_mines: 1},
        %Coordinates{x: 1, y: 2} => %Cell{num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 0} => %Cell{num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 1} => %Cell{num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 2} => %Cell{num_adjacent_mines: 0}
      }
    }

    assert Game.unflag(initial_game, %Coordinates{x: 0, y: 1}) ==
             {:invalid_instruction, initial_game}
  end

  test "unflagging a non-flagged cell is not supported" do
    initial_game = %Game{
      state: :ongoing,
      width: 3,
      height: 3,
      number_of_mines: 1,
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

    assert Game.unflag(initial_game, %Coordinates{x: 0, y: 1}) ==
             {:invalid_instruction, initial_game}
  end

  test "unflagging a non-existing cell (aka bad coordinates) returns an error" do
    initial_game = %Game{
      state: :ongoing,
      width: 3,
      height: 3,
      number_of_mines: 0,
      cells: %{
        %Coordinates{x: 0, y: 0} => %Cell{},
        %Coordinates{x: 0, y: 1} => %Cell{},
        %Coordinates{x: 0, y: 2} => %Cell{},
        %Coordinates{x: 1, y: 0} => %Cell{},
        %Coordinates{x: 1, y: 1} => %Cell{},
        %Coordinates{x: 1, y: 2} => %Cell{},
        %Coordinates{x: 2, y: 0} => %Cell{},
        %Coordinates{x: 2, y: 1} => %Cell{},
        %Coordinates{x: 2, y: 2} => %Cell{}
      }
    }

    assert Game.unflag(initial_game, %Coordinates{x: 0, y: 3}) ==
             {:invalid_coordinates, initial_game}

    assert Game.unflag(initial_game, %Coordinates{x: 3, y: 0}) ==
             {:invalid_coordinates, initial_game}

    assert Game.unflag(initial_game, %Coordinates{x: 3, y: 3}) ==
             {:invalid_coordinates, initial_game}
  end

  test "revealing the last cell(s) & all mines flagged is win condition - single cell reveal" do
    initial_game = %Game{
      state: :ongoing,
      width: 3,
      height: 3,
      number_of_mines: 2,
      cells: %{
        %Coordinates{x: 0, y: 0} => %Cell{revealed: true, num_adjacent_mines: 1},
        %Coordinates{x: 0, y: 1} => %Cell{mined: true, flagged: true, num_adjacent_mines: 1},
        %Coordinates{x: 0, y: 2} => %Cell{revealed: false, mined: false, num_adjacent_mines: 2},
        %Coordinates{x: 1, y: 0} => %Cell{revealed: true, mined: false, num_adjacent_mines: 1},
        %Coordinates{x: 1, y: 1} => %Cell{revealed: true, mined: false, num_adjacent_mines: 2},
        %Coordinates{x: 1, y: 2} => %Cell{mined: true, flagged: true, num_adjacent_mines: 1},
        %Coordinates{x: 2, y: 0} => %Cell{revealed: true, mined: false, num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 1} => %Cell{revealed: true, mined: false, num_adjacent_mines: 1},
        %Coordinates{x: 2, y: 2} => %Cell{revealed: true, mined: false, num_adjacent_mines: 1}
      }
    }

    assert Game.reveal(initial_game, %Coordinates{x: 0, y: 2}) ==
             {:ok,
              %Game{
                state: :game_won,
                width: 3,
                height: 3,
                number_of_mines: 2,
                cells: %{
                  %Coordinates{x: 0, y: 0} => %Cell{
                    revealed: true,
                    num_adjacent_mines: 1
                  },
                  %Coordinates{x: 0, y: 1} => %Cell{
                    flagged: true,
                    mined: true,
                    num_adjacent_mines: 1
                  },
                  %Coordinates{x: 0, y: 2} => %Cell{
                    revealed: true,
                    num_adjacent_mines: 2
                  },
                  %Coordinates{x: 1, y: 0} => %Cell{
                    revealed: true,
                    num_adjacent_mines: 1
                  },
                  %Coordinates{x: 1, y: 1} => %Cell{
                    revealed: true,
                    num_adjacent_mines: 2
                  },
                  %Coordinates{x: 1, y: 2} => %Cell{
                    mined: true,
                    flagged: true,
                    num_adjacent_mines: 1
                  },
                  %Coordinates{x: 2, y: 0} => %Cell{
                    revealed: true,
                    num_adjacent_mines: 0
                  },
                  %Coordinates{x: 2, y: 1} => %Cell{
                    revealed: true,
                    num_adjacent_mines: 1
                  },
                  %Coordinates{x: 2, y: 2} => %Cell{
                    revealed: true,
                    num_adjacent_mines: 1
                  }
                }
              }}
  end

  test "revealing the last cell(s) & all mines flagged is win condition - multiple safe cell reveal" do
    initial_game = %Game{
      state: :ongoing,
      width: 3,
      height: 3,
      number_of_mines: 1,
      cells: %{
        %Coordinates{x: 0, y: 0} => %Cell{mined: true, flagged: true, num_adjacent_mines: 0},
        %Coordinates{x: 0, y: 1} => %Cell{revealed: true, num_adjacent_mines: 1},
        %Coordinates{x: 0, y: 2} => %Cell{revealed: false, num_adjacent_mines: 0},
        %Coordinates{x: 1, y: 0} => %Cell{revealed: true, num_adjacent_mines: 1},
        %Coordinates{x: 1, y: 1} => %Cell{revealed: true, num_adjacent_mines: 1},
        %Coordinates{x: 1, y: 2} => %Cell{revealed: false, num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 0} => %Cell{revealed: false, num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 1} => %Cell{revealed: false, num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 2} => %Cell{revealed: false, num_adjacent_mines: 0}
      }
    }

    assert Game.reveal(initial_game, %Coordinates{x: 2, y: 2}) ==
             {:ok,
              %Game{
                state: :game_won,
                width: 3,
                height: 3,
                number_of_mines: 1,
                cells: %{
                  %Coordinates{x: 0, y: 0} => %Cell{
                    mined: true,
                    flagged: true,
                    num_adjacent_mines: 0
                  },
                  %Coordinates{x: 0, y: 1} => %Cell{revealed: true, num_adjacent_mines: 1},
                  %Coordinates{x: 0, y: 2} => %Cell{revealed: true, num_adjacent_mines: 0},
                  %Coordinates{x: 1, y: 0} => %Cell{revealed: true, num_adjacent_mines: 1},
                  %Coordinates{x: 1, y: 1} => %Cell{revealed: true, num_adjacent_mines: 1},
                  %Coordinates{x: 1, y: 2} => %Cell{revealed: true, num_adjacent_mines: 0},
                  %Coordinates{x: 2, y: 0} => %Cell{revealed: true, num_adjacent_mines: 0},
                  %Coordinates{x: 2, y: 1} => %Cell{revealed: true, num_adjacent_mines: 0},
                  %Coordinates{x: 2, y: 2} => %Cell{revealed: true, num_adjacent_mines: 0}
                }
              }}
  end

  test "flagging the last mine, when all other mines are flagged & non-mined cells revealed is win condition" do
    initial_game = %Game{
      state: :ongoing,
      width: 3,
      height: 3,
      number_of_mines: 1,
      cells: %{
        %Coordinates{x: 0, y: 0} => %Cell{mined: true, flagged: false, num_adjacent_mines: 0},
        %Coordinates{x: 0, y: 1} => %Cell{revealed: true, num_adjacent_mines: 1},
        %Coordinates{x: 0, y: 2} => %Cell{revealed: true, num_adjacent_mines: 0},
        %Coordinates{x: 1, y: 0} => %Cell{revealed: true, num_adjacent_mines: 1},
        %Coordinates{x: 1, y: 1} => %Cell{revealed: true, num_adjacent_mines: 1},
        %Coordinates{x: 1, y: 2} => %Cell{revealed: true, num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 0} => %Cell{revealed: true, num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 1} => %Cell{revealed: true, num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 2} => %Cell{revealed: true, num_adjacent_mines: 0}
      }
    }

    assert Game.flag(initial_game, %Coordinates{x: 0, y: 0}) ==
             {:ok,
              %Game{
                state: :game_won,
                width: 3,
                height: 3,
                number_of_mines: 1,
                cells: %{
                  %Coordinates{x: 0, y: 0} => %Cell{
                    mined: true,
                    flagged: true,
                    num_adjacent_mines: 0
                  },
                  %Coordinates{x: 0, y: 1} => %Cell{revealed: true, num_adjacent_mines: 1},
                  %Coordinates{x: 0, y: 2} => %Cell{revealed: true, num_adjacent_mines: 0},
                  %Coordinates{x: 1, y: 0} => %Cell{revealed: true, num_adjacent_mines: 1},
                  %Coordinates{x: 1, y: 1} => %Cell{revealed: true, num_adjacent_mines: 1},
                  %Coordinates{x: 1, y: 2} => %Cell{revealed: true, num_adjacent_mines: 0},
                  %Coordinates{x: 2, y: 0} => %Cell{revealed: true, num_adjacent_mines: 0},
                  %Coordinates{x: 2, y: 1} => %Cell{revealed: true, num_adjacent_mines: 0},
                  %Coordinates{x: 2, y: 2} => %Cell{revealed: true, num_adjacent_mines: 0}
                }
              }}
  end

  test "a game won no longer accepts commands" do
    game = %Game{
      state: :game_won,
      width: 3,
      height: 3,
      cells: %{
        %Coordinates{x: 0, y: 0} => %Cell{
          mined: true,
          revealed: false,
          flagged: true,
          num_adjacent_mines: 0
        },
        %Coordinates{x: 0, y: 1} => %Cell{revealed: true, num_adjacent_mines: 1},
        %Coordinates{x: 0, y: 2} => %Cell{revealed: true, num_adjacent_mines: 0},
        %Coordinates{x: 1, y: 0} => %Cell{revealed: true, num_adjacent_mines: 1},
        %Coordinates{x: 1, y: 1} => %Cell{revealed: true, num_adjacent_mines: 1},
        %Coordinates{x: 1, y: 2} => %Cell{revealed: true, num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 0} => %Cell{revealed: true, num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 1} => %Cell{revealed: true, num_adjacent_mines: 0},
        %Coordinates{x: 2, y: 2} => %Cell{revealed: true, num_adjacent_mines: 0}
      }
    }

    assert Game.flag(game, %Coordinates{x: 0, y: 0}) ==
             {:game_over, game}

    assert Game.unflag(game, %Coordinates{x: 0, y: 0}) ==
             {:game_over, game}

    assert Game.reveal(game, %Coordinates{x: 0, y: 0}) ==
             {:game_over, game}
  end

  test "a game lost no longer accepts commands" do
    game = %Game{
      state: :game_lost,
      width: 3,
      height: 3,
      number_of_mines: 1,
      cells: %{
        %Coordinates{x: 0, y: 0} => %Cell{
          mined: true,
          revealed: true,
          flagged: false,
          num_adjacent_mines: 0
        },
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

    assert Game.flag(game, %Coordinates{x: 0, y: 0}) ==
             {:game_over, game}

    assert Game.unflag(game, %Coordinates{x: 0, y: 0}) ==
             {:game_over, game}

    assert Game.reveal(game, %Coordinates{x: 0, y: 0}) ==
             {:game_over, game}
  end
end
