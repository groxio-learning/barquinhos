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

  def to_points(%Ship{} = ship) do
  end

  def hit?(%Ship{} = ship, shot) do
  end
end
