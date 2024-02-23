defmodule Minesweeper.Coordinates do
  defstruct [:x, :y]

  @type t :: %Minesweeper.Coordinates{x: integer, y: integer}
end

defmodule Minesweeper.Cell do
  defstruct revealed: false

  @type t :: %Minesweeper.Cell{revealed: boolean()}
end

defmodule Minesweeper.Game do
  defstruct [:width, :height, :cells]

  @type t :: %Minesweeper.Game{
          width: integer,
          height: integer,
          cells: %{Minesweeper.Coordinates.t() => Minesweeper.Cell.t()}
        }

  def create(width, height),
    do: %Minesweeper.Game{width: width, height: height, cells: create_cells(width, height)}

  defp create_cells(width, height) do
    for x <- 0..(height-1), y <- 0..(width-1), into: %{} do
      {%Minesweeper.Coordinates{x: x, y: y}, %Minesweeper.Cell{}}
    end
  end
end
