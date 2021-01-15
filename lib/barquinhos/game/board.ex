defmodule Barquinhos.Game.Board do
  alias Barquinhos.Game.{Board, Ship}

  defstruct ships: [], shots: []

  # constructor
  def new do
    %__MODULE__{}
  end

  # reducer
  def add_ship(%Board{} = board, ship) do
    # Add ship to board's ship
    %{board | ships: board.ships++[ship]}
  end

  # reducer
  def attack(%Board{} = board, shot) do
    %{board | shots: board.shots++[shot]}
  end

  # converter
  def hit?(%Board{} = board, shot) do
    # call hit on ship
    Enum.any?(board.ships, fn ship -> Ship.hit?(ship, shot) end)
  end

  def game_over?(%Board{} = board) do
    false
  end
end
