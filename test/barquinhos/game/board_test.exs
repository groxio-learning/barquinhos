defmodule Barquinhos.Game.BoardTest do
  use ExUnit.Case

  alias Barquinhos.Game.{Board, Ship, Player}

  # setup do
  #   ship = Ship.new({1, 1}, :horizontal, :submarine)
  #   new_board = Board.new() |> Board.add_ship(ship)
  #   %{new_board: new_board}
  # end

  # describe "add_ship/2" do
  #   test "adds ship to the board", %{new_board: new_board} do
  #     actual = new_board

  #     expected = %Board{
  #       ships: [
  #         %Ship{starting_point: {1, 1}, orientation: :horizontal, size: 3, type: :submarine}
  #       ]
  #     }

  #     assert actual == expected
  #   end
  # end

  # describe "attack" do
  #   test "registers the shot", %{new_board: new_board} do
  #   end
  # end

  # describe "hit?" do
  #   test "finds if a ship has been hit" do
  #   end
  # end

  # describe "game_over?" do
  #   test "check if the game is over" do
  #   end
  # end

  # describe "board journey" do
  #   test "play hard game" do
  #     destroyer = Ship.new({1, 1}, :horizontal, :destroyer)
  #     submarine = Ship.new({5, 5}, :horizontal, :submarine)

  #     actual =
  #       Board.new()
  #       |> assert_status_key(:status, :ready)
  #       |> Board.add_ship(destroyer)
  #       |> Board.add_ship(submarine)
  #       |> Board.attack({1, 1})
  #   end
  # end

  describe "last_shooter" do
    setup do
      player = Player.new()
      %{player: player}
    end

    test "player is last shooter", %{player: player} do
      Board.new()
      |> Board.set_last_shooter(player)
      |> Board.is_last_shooter(player)
      |> assert
    end
    test "player is not the last shooter", %{player: player} do
      Board.new()
      |> Board.is_last_shooter(player)
      |> refute
    end
  end

  defp assert_status_key(actual, key, value) do
    assert Map.get(actual, key) == value
    actual
  end
end
