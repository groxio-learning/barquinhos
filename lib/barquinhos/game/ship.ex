defmodule Barquinhos.Game.Ship do
  alias Barquinhos.Game.Ship

  @ship_types [:submarine, :destroyer, :battleship, :carrier, :cruiser]

  defstruct starting_point: [{1, 1}],
            orientation: :vertical,
            size: 3,
            sunk: false,
            type: :submarine

  def new(point, orientation, sunk, type) when type in @ship_types do
    %__MODULE__{
      starting_point: point,
      orientation: orientation,
      size: get_size(type),
      sunk: sunk,
      type: type
    }
  end

  defp get_size(:submarine), do: 3
  defp get_size(:destroyer), do: 2
  defp get_size(:cruiser), do: 3
  defp get_size(:battleship), do: 4
  defp get_size(:carrier), do: 5

  def to_points(%Ship{orientation: :horizontal, starting_point: {x, y}} = ship) do
    for n <- y..(y - 1 + get_size(ship.type)), do: {x, n}
  end

  def to_points(%Ship{orientation: :vertical, starting_point: {x, y}} = ship) do
    for n <- x..(x - 1 + get_size(ship.type)), do: {n, y}
  end
end
