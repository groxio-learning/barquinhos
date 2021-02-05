defmodule Barquinhos.Game.Board do
  alias Barquinhos.Game.Ship

  # ship-hit, miss, ship-sunk, gameover, ready
  defstruct ships: [], shots: [], status: :ready

  # constructor
  def new do
    %__MODULE__{}
  end

  # reducer
  def add_ship(%__MODULE__{} = board, ship) do
    # Add ship to board's ship
    %{board | ships: [ship | board.ships]}
  end

  # reducer
  def attack(%__MODULE__{} = board, shot) do
    %{board | shots: [shot | board.shots]}
  end

  # converter
  def hit?(%__MODULE__{} = board, shot) do
    # call hit on ship
    Enum.any?(board.ships, fn ship -> Ship.hit?(ship, shot) end)
  end

  def maybe_ship_type(nil, _sunk), do: nil
  def maybe_ship_type(_ship, false), do: nil
  def maybe_ship_type(ship, true), do: ship.type

  def sunk_ship_name(%__MODULE__{shots: [last_shot|_rest]} = board) do
    hit_ship = board.ships
    |> Enum.find(fn ship -> Ship.hit?(ship, last_shot) end) #ship or nil

    maybe_ship_type(hit_ship, Ship.sunk?(hit_ship, last_shot))
  end
  def sunk_ship_name(_), do: nil

  def game_over?(%__MODULE__{} = board) do
    Enum.all?(board.ships, fn ship -> Ship.sunk?(ship, board.shots) end)
  end

  def status(board, shot) do
    sunk_ship = sunk_ship_name(board)
    cond do
      game_over?(board) -> %{board | status: :gameover}
      not hit?(board, shot) -> %{board | status: :miss}
      is_nil(sunk_ship) -> %{board | status: :hit}
      true -> %{board | status: sunk_ship}
    end
  end

end
