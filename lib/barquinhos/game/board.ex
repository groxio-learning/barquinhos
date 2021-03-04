defmodule Barquinhos.Game.Board do
  alias Barquinhos.Game.Ship

  @enforce_keys [:size]

  @default_size {9, 9}

  # board size, ships list and shots list
  defstruct size: nil, ships: [], shots: []

  # constructor
  def new({x, y} = size) when is_number(x) and is_number(y) do
    %__MODULE__{size: size}
  end

  def new(_size) do
    %__MODULE__{size: @default_size}
  end

  # reducer
  def add_ship(%__MODULE__{} = board, ship) do
    # Add ship to board's ship
    %{board | ships: [ship | board.ships]}
  end

  # reducer
  def add_shot(%__MODULE__{} = board, shot) do
    %{board | shots: [shot | board.shots]}
  end
end
