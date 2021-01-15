defmodule Barquinhos.Game.Ship do
  alias Barquinhos.Game.Ship

  defstruct [coordinates: {0,0}, orientation: :vertical, size: 3]

  def new(point, orientation, size) do
    %__MODULE__{
      coordinates: point,
      orientation: orientation,
      size: size
    }
  end

  def to_points(%Ship{orientation: :vertical, coordinates: {x, y}} = ship) do
    for n <- y..(y-1 + ship.size), do: {x, n}
  end

  def to_points(%Ship{orientation: :horizontal, coordinates: {x, y}} = ship) do
    for n <- x..(x-1 + ship.size), do: {n, y}
  end

  def hit?(%Ship{} = ship, shot) do
  end
end
