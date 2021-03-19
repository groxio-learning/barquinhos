defmodule Barquinhos.Game.BoardTest do
  use ExUnit.Case

  alias Barquinhos.Game.{Board, Ship}

  setup do
    ship = Ship.new([{1, 1}], :horizontal, false, :submarine)
    new_board = Board.new(size: {}) |> Board.add_ship(ship)
    %{new_board: new_board}
  end

  describe "add_ship/2" do
    test "adds ship to the board", %{new_board: new_board} do
      actual = new_board

      expected = %Board{
        size: {9, 9},
        ships: [
          %Ship{starting_point: [{1, 1}], orientation: :horizontal, size: 3, type: :submarine}
        ]
      }

      assert actual == expected
    end
  end

  describe "attack" do
    test "registers the shot", %{new_board: new_board} do
    end
  end

  describe "board journey" do
    test "play hard game" do
      destroyer = Ship.new({1, 1}, :horizontal, false, :destroyer)
      submarine = Ship.new({5, 5}, :horizontal, false, :submarine)

      actual =
        Board.new(size: {})
        |> Board.add_ship(destroyer)
        |> Board.add_ship(submarine)
        |> Board.add_shot({1, 1})
    end
  end
end
