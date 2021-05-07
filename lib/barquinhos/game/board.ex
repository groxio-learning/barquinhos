defmodule Barquinhos.Game.Board do
  alias Barquinhos.Game.Ship

  # ship-hit, miss, ship-sunk, gameover, ready
  defstruct ships: [], shots: [], opponent_hits: [], status: :ready
  #shots_sent,  successful_shots
  #direct hit

  # constructor
  def new do
    %__MODULE__{}
  end

  # #reference
  #   defp ships(%{assigns: %{ships: ships}} = socket, ship) do
  #     assign(socket, ships: [new_ship(socket, ship) | ships])
  #   end
  #
  #   defp new_ship(%{assigns: %{ship_type: ship_type, ship_orientation: ship_orientation}}, points) do
  #     Ship.new(points, ship_orientation, ship_type)
  #   end

  # reducer
  def add_ship(%__MODULE__{} = board, x, y, ship_orientation, ship_type) do
    starting_point = {String.to_integer(x), String.to_integer(y)}
    ship = Ship.new(starting_point, ship_orientation, ship_type)
    %{board | ships: [ship | board.ships]}
  end

  # reducer
  def attack(%__MODULE__{} = board, x, y) do
    shot = {String.to_integer(x), String.to_integer(y)}
    %{board | shots: [shot | board.shots]}
  end

  def add_opponent_hit(%__MODULE__{} = board, x, y) do
    shot = {String.to_integer(x), String.to_integer(y)}
    %{board | opponent_hits: [shot | board.opponent_hits]}
  end

  # converter
  def hit?(%__MODULE__{} = board, shot) do
    # call hit on ship
    Enum.any?(board.ships, fn ship -> Ship.hit?(ship, shot) end)
  end

  # TODO: I think this function its not use
  defp maybe_ship_type(nil, _sunk), do: nil
  defp maybe_ship_type(_ship, false), do: nil
  defp maybe_ship_type(ship, true), do: ship.type

  defp sunk_ship(%__MODULE__{shots: [last_shot | _rest]} = board) do
    hit_ship =
      board.ships
      # ship or nil
      |> Enum.find(fn ship -> Ship.hit?(ship, last_shot) end)

    maybe_ship_type(hit_ship, Ship.sunk?(hit_ship, last_shot))
  end

  defp sunk_ship(_), do: nil

  defp game_over?(%__MODULE__{} = board) do
    Enum.all?(board.ships, fn ship -> Ship.sunk?(ship, board.shots) end)
  end

  def status(board, shot) do
    cond do
      game_over?(board) -> %{board | status: :gameover}
      not hit?(board, shot) -> %{board | status: :miss}
      is_nil(sunk_ship(board)) -> %{board | status: :hit}
      true -> %{board | status: sunk_ship(board)}
    end
  end
end
