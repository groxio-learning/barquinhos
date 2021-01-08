defmodule Barquinhos.Game.Board do
  alias Barquinhos.Game.Ship

  defstruct [ships: [], shots: []]

  #constructor
  def new do
    %__MODULE__{}
  end

  #reducer
  def new_ship(board, _ship) do
    board
  end

  #reducer
  def attack(board, _shot) do
    board
  end

end
