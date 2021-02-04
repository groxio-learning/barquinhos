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

  def sunk?(%__MODULE__{} = board) do
    Enum.any?(board.ships, fn ship -> Ship.sunk?(ship, board.shots) end)
  end

  def game_over?(%__MODULE__{} = board) do
    Enum.all?(board.ships, fn ship -> Ship.sunk?(ship, board.shots) end)
  end

  def status(board, shot) do
    cond do
      game_over?(board) -> %{board | status: :gameover}
      sunk?(board) -> %{board | status: :sunk}
      not hit?(board, shot) -> %{board | status: :miss}
      true -> %{board | status: :hit}
    end
  end
  
end
