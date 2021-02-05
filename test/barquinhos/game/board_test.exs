defmodule Barquinhos.Game.BoardTest do
  use ExUnit.Case

  alias Barquinhos.Game.{Board, Ship}

  setup do
    ship = Ship.new({1, 1}, :horizontal, 2)
    new_board = Board.new() |> Board.add_ship(ship)
    {:ok, new_board: new_board}
  end

  describe "add_ship" do
    test "adds ship to the board", %{new_board: new_board} do
      actual = new_board
      expected = %Board{ships: [%Ship{starting_point: {1, 1}, orientation: :horizontal, size: 2, type: :submarine}]}
      assert actual == expected
    end
  end

  describe "attack" do
    test "registers the shot", %{new_board: new_board} do
    end
  end

  describe "hit?" do
    test "finds if a ship has been hit" do
    end
  end

  describe "game_over?" do
    test "check if the game is over" do
    end
  end
end
