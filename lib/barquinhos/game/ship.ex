defmodule Barquinhos.Game.Ship do
  alias Barquinhos.Game.Ship

  @ship_types [:submarine, :destroyer, :battleship, :carrier, :cruiser]

  defstruct coordinates: {0, 0}, orientation: :vertical, size: 3, type: :submarine

  def new(point, orientation, type) when type in @ship_types do
    %__MODULE__{
      coordinates: point,
      orientation: orientation,
      size: get_size(type),
      type: type
    }
  end 

  defp get_size(:submarine), do: 3
  defp get_size(:destroyer), do: 2
  defp get_size(:cruiser), do: 3
  defp get_size(:battleship), do: 4
  defp get_size(:carrier), do: 5

  def to_points(%Ship{orientation: :vertical, coordinates: {x, y}} = ship) do
    for n <- y..(y - 1 + ship.size), do: {x, n}
  end

  def to_points(%Ship{orientation: :horizontal, coordinates: {x, y}} = ship) do
    for n <- x..(x - 1 + ship.size), do: {n, y}
  end

  def hit?(%Ship{} = ship, shot) do
    shot in to_points(ship)
  end

  def sunk?(%Ship{} = ship, all_shots) do
    ship
    |> to_points()
    |> Kernel.--(all_shots)
    |> Enum.empty?()
  end
end
