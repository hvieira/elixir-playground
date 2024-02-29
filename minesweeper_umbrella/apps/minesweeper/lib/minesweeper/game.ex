defmodule Minesweeper.Coordinates do
  defstruct [:x, :y]

  @type t :: %Minesweeper.Coordinates{x: integer, y: integer}
end

defmodule Minesweeper.Cell do
  defstruct revealed: false, mined: false, flagged: false, num_adjacent_mines: 0

  @type t :: %Minesweeper.Cell{revealed: boolean(), mined: boolean(), num_adjacent_mines: integer}
end

defmodule Minesweeper.Game do
  @invalid_coordinates :invalid_coordinates
  @invalid_instruction :invalid_instruction

  defstruct [:state, :width, :height, :number_of_mines, :cells]

  @type t :: %Minesweeper.Game{
          width: integer,
          height: integer,
          cells: %{Minesweeper.Coordinates.t() => Minesweeper.Cell.t()}
        }

  def create(width, height, number_of_mines, mine_picker_func \\ &Enum.take_random/2),
    do: %Minesweeper.Game{
      state: :ongoing,
      width: width,
      height: height,
      number_of_mines: number_of_mines,
      cells: create_cells(width, height, number_of_mines, mine_picker_func)
    }

  def reveal(%Minesweeper.Game{state: game_state} = game, _coordinates)
      when game_state == :game_lost or game_state == :game_won do
    {:game_over, game}
  end

  def reveal(%Minesweeper.Game{} = game, coordinates),
    do: reveal_cell(game, coordinates, Map.get(game.cells, coordinates))

  def flag(%Minesweeper.Game{state: game_state} = game, _coordinates)
      when game_state == :game_lost or game_state == :game_won do
    {:game_over, game}
  end

  def flag(%Minesweeper.Game{} = game, coordinates) do
    case Map.get(game.cells, coordinates) do
      %Minesweeper.Cell{revealed: false} ->
        updated_game = %{
          game
          | cells: Map.update!(game.cells, coordinates, fn c -> %{c | flagged: true} end)
        }

        {:ok, updated_game |> update_game_state()}

      %Minesweeper.Cell{revealed: true} ->
        {@invalid_instruction, game}

      nil ->
        {@invalid_coordinates, game}
    end
  end

  def unflag(%Minesweeper.Game{state: game_state} = game, _coordinates)
      when game_state == :game_lost or game_state == :game_won do
    {:game_over, game}
  end

  def unflag(%Minesweeper.Game{} = game, coordinates) do
    case Map.get(game.cells, coordinates) do
      %Minesweeper.Cell{flagged: false} ->
        {@invalid_instruction, game}

      %Minesweeper.Cell{revealed: false, flagged: true} ->
        {:ok,
         %{game | cells: Map.update!(game.cells, coordinates, fn c -> %{c | flagged: false} end)}}

      %Minesweeper.Cell{revealed: true} ->
        {@invalid_instruction, game}

      nil ->
        {@invalid_coordinates, game}
    end
  end

  defp reveal_cell(game, _coordinates, nil), do: {@invalid_coordinates, game}

  defp reveal_cell(game, _coordinates, %Minesweeper.Cell{revealed: true, mined: false}),
    do: {:ok, game}

  defp reveal_cell(game, coordinates, %Minesweeper.Cell{
         mined: true
       }),
       do:
         {:ok,
          %{
            game
            | cells:
                Map.update!(game.cells, coordinates, fn cell -> %{cell | revealed: true} end),
              state: :game_lost
          }}

  # TODO check if this and the next pattern match might be merged into 1 (as long as the recursive reveal can handle this scenario)
  defp reveal_cell(game, coordinates, %Minesweeper.Cell{
         revealed: false,
         mined: false,
         num_adjacent_mines: mines_around
       })
       when mines_around > 0 do
    updated_game = %{
      game
      | cells: Map.update!(game.cells, coordinates, fn cell -> %{cell | revealed: true} end)
    }

    {:ok, updated_game |> update_game_state()}
  end

  defp reveal_cell(game, coordinates, %Minesweeper.Cell{
         revealed: false,
         mined: false,
         num_adjacent_mines: mines
       })
       when mines == 0 do
    updated_game = reveal_all_safe_cells(game, [coordinates])
    {:ok, updated_game |> update_game_state()}
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

  defp update_game_state(game) do
    number_of_non_mined_cells = game.width * game.height - game.number_of_mines

    stats =
      Enum.reduce(game.cells, [flagged_mines: 0, revealed_cells: 0], fn {_coordinates, cell},
                                                                        acc ->
        case cell do
          %Minesweeper.Cell{revealed: true, mined: false, flagged: false} ->
            Keyword.update!(acc, :revealed_cells, &(&1 + 1))

          %Minesweeper.Cell{revealed: false, mined: true, flagged: true} ->
            Keyword.update!(acc, :flagged_mines, &(&1 + 1))

          _ ->
            acc
        end
      end)

    # IO.inspect(stats)
    case stats do
      [flagged_mines: fm, revealed_cells: rc]
      when fm == game.number_of_mines and rc == number_of_non_mined_cells ->
        %{game | state: :game_won}

      _ ->
        game
    end
  end
end
