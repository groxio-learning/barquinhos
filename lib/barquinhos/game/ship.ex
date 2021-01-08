defmodule Barquinhos.Game.Ship do
  alias Barquinhos.Game.Board

  defstruct [coordinates: {0,0}, orientation: :vertical, size: 3]

  def new(point, orientation, size) do
    %__MODULE__{
      coordinates: point,
      orientation: orientation,
      size: size
    }
  end

end
