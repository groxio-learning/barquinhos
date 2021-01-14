defmodule Barquinhos.Game.Board do
  alias Barquinhos.Game.{Board, Ship}

  defstruct [ships: [], shots: []]

  #constructor
  def new do
    %__MODULE__{}
  end

  #reducer
  def add_ship(%Board{} = board, ship) do
    board
  end

  #reducer
  def attack(%Board{} = board, shot) do
    board
  end

  # converter
  def game_over?(%Board{} = board) do
  end

  def hit?(%Board{} = board, shot) do
  end
end
