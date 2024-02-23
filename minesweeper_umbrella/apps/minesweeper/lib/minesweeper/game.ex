defmodule Minesweeper.Coordinates do
  defstruct [:x, :y]

  @type t :: %Minesweeper.Coordinates{x: integer, y: integer}
end

defmodule Minesweeper.Cell do
  defstruct revealed: false, mined: false

  @type t :: %Minesweeper.Cell{revealed: boolean(), mined: boolean()}
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

  defp create_cells(width, height, number_of_mines, mine_picker_func) do
    unmined_cells =
      for x <- 0..(height - 1), y <- 0..(width - 1), into: %{} do
        {%Minesweeper.Coordinates{x: x, y: y}, %Minesweeper.Cell{}}
      end

    unmined_cells
    |> mine_picker_func.(number_of_mines)
    |> Enum.reduce(unmined_cells, fn cell_to_mine, acc ->
      acc |> Map.update!(elem(cell_to_mine, 0), fn cell -> %{cell | mined: true} end)
    end)
  end
end
