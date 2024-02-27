defmodule Minesweeper.Coordinates do
  defstruct [:x, :y]

  @type t :: %Minesweeper.Coordinates{x: integer, y: integer}
end

defmodule Minesweeper.Cell do
  defstruct revealed: false, mined: false, num_adjacent_mines: 0

  @type t :: %Minesweeper.Cell{revealed: boolean(), mined: boolean(), num_adjacent_mines: integer}
end

defmodule Minesweeper.Game do
  defstruct [:width, :height, :cells]

  @type t :: %Minesweeper.Game{
          width: integer,
          height: integer,
          cells: %{Minesweeper.Coordinates.t() => Minesweeper.Cell.t()}
        }

  def create(width, height, number_of_mines, mine_picker_func \\ &Enum.take_random/2),
    do: %Minesweeper.Game{
      width: width,
      height: height,
      cells: create_cells(width, height, number_of_mines, mine_picker_func)
    }

  def reveal(%Minesweeper.Game{} = game, coordinates),
    do: reveal_cell(game, coordinates, Map.get(game.cells, coordinates))

  defp reveal_cell(game, _coordinates, nil), do: {:invalid_coordinates, game}

  defp reveal_cell(game, _coordinates, %Minesweeper.Cell{revealed: true, mined: false}),
    do: {:ok, game}

  defp reveal_cell(game, coordinates, %Minesweeper.Cell{
         mined: true
       }),
       do:
         {:lost,
          %{
            game
            | cells: Map.update!(game.cells, coordinates, fn cell -> %{cell | revealed: true} end)
          }}

  defp reveal_cell(game, coordinates, %Minesweeper.Cell{
         revealed: false,
         mined: false,
         num_adjacent_mines: mines
       })
       when mines > 0 do
    {:ok,
     %{
       game
       | cells: Map.update!(game.cells, coordinates, fn cell -> %{cell | revealed: true} end)
     }}
  end

  defp reveal_cell(game, coordinates, %Minesweeper.Cell{
         revealed: false,
         mined: false,
         num_adjacent_mines: mines
       })
       when mines == 0 do
    {:ok, reveal_all_safe_cells(game, [coordinates])}
  end

  defp reveal_all_safe_cells(game_state, coordinates_to_explore, explored \\ MapSet.new())
  defp reveal_all_safe_cells(game_state, [], _explored), do: game_state

  defp reveal_all_safe_cells(game_state, [current_coordinates | t], explored) do
    case MapSet.member?(explored, current_coordinates) do
      true ->
        reveal_all_safe_cells(game_state, t, explored)

      false ->
        case Map.get(game_state.cells, current_coordinates) do
          %Minesweeper.Cell{num_adjacent_mines: mines} when mines == 0 ->
            reveal_all_safe_cells(
              %{
                game_state
                | cells:
                    Map.update!(game_state.cells, current_coordinates, fn cell ->
                      %{cell | revealed: true}
                    end)
              },
              Enum.concat(t, get_adjacent_cells(current_coordinates, game_state.cells)),
              MapSet.put(explored, current_coordinates)
            )

          _ ->
            reveal_all_safe_cells(game_state, t, MapSet.put(explored, current_coordinates))
        end
    end
  end

  defp create_cells(width, height, number_of_mines, mine_picker_func) do
    unmined_field =
      for x <- 0..(height - 1), y <- 0..(width - 1), into: %{} do
        {%Minesweeper.Coordinates{x: x, y: y}, %Minesweeper.Cell{}}
      end

    mined_field =
      unmined_field
      |> mine_picker_func.(number_of_mines)
      |> Enum.reduce(unmined_field, fn cell_to_mine, acc ->
        acc |> Map.update!(elem(cell_to_mine, 0), fn cell -> %{cell | mined: true} end)
      end)

    # compute number of adjacent mines per cell
    for x <- 0..(height - 1), y <- 0..(width - 1), into: %{} do
      target_coordinates = %Minesweeper.Coordinates{x: x, y: y}

      {target_coordinates,
       %{
         Map.get(mined_field, target_coordinates)
         | num_adjacent_mines: get_number_of_adjacent_mines(target_coordinates, mined_field)
       }}
    end
  end

  defp get_number_of_adjacent_mines(target_coordinates, field) do
    target_coordinates
    |> get_adjacent_cells(field)
    |> Enum.count(fn coordinates -> Map.get(field, coordinates).mined end)
  end

  defp get_adjacent_cells(target_coordinates, game_cells) do
    for x <- (target_coordinates.x - 1)..(target_coordinates.x + 1),
        y <- (target_coordinates.y - 1)..(target_coordinates.y + 1),
        Map.has_key?(game_cells, %Minesweeper.Coordinates{x: x, y: y}),
        into: MapSet.new() do
      %Minesweeper.Coordinates{x: x, y: y}
    end
    # remove the target_coordinates from the set (its the adjacent cells and should not include the target ones)
    |> MapSet.delete(target_coordinates)
  end
end
