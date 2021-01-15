defmodule ShipTest do
  use ExUnit.Case

  alias Barquinhos.Game.Ship

  test "returns the vertical points based on ship size" do
    ship = %Ship{coordinates: {5,5}}

    assert Ship.to_points(ship) == [{5, 5}, {5, 6}, {5, 7}]
  end
end
