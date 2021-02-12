defmodule BarquinhosWeb.GameLive do
  use BarquinhosWeb, :live_view
  alias Barquinhos.Game.{Board, Ship}

  def mount(_params, _session, socket) do
    {:ok, socket |> build}
  end

  def build(socket) do
    socket
    |> ships()
    |> board()
    |> points()
    |> ship_type(nil)
    |> ship_orientation(nil)
    |> game_status(:placing)
  end

  defp ships(socket) do
    assign(socket, ships: [])
  end

  defp points(socket) do
    assign(socket, points: [])
  end

  defp board(socket) do
    assign(socket, board: Board.new())
  end

  defp ship_type(socket, ship_type) when is_atom(ship_type) do
    assign(socket, ship_type: ship_type)
  end

  defp ship_type(socket, _) do
    assign(socket, ship_type: nil)
  end

  defp ship_orientation(socket, ship_orientation) when is_atom(ship_orientation) do
    assign(socket, ship_orientation: ship_orientation)
  end

  defp ship_orientation(socket, _) do
    assign(socket, ship_orientation: nil)
  end

  defp ships(%{assigns: %{ships: ships}} = socket, ship) do
    assign(socket, ships: [new_ship(socket, ship) | ships])
  end

  defp new_ship(%{assigns: %{ship_type: ship_type, ship_orientation: ship_orientation}}, points) do
    Ship.new(points, ship_orientation, ship_type)
  end

  defp to_points(%{assigns: %{ships: ships}} = socket) do
    my_ships =
      ships
      |> Enum.map(&Ship.to_points/1)
      |> List.flatten()
      |> Enum.map(fn {x, y} -> "#{x}#{y}" end)

    assign(socket, points: my_ships)
  end

  defp game_status(socket, status), do: assign(socket, game_status: status)

  defp game_status(%{assigns: %{ships: ships}} = socket) when length(ships) == 5 do
    assign(socket, game_status: :ready)
  end

  defp game_status(socket), do: socket

  def handle_event(
        "add_ship",
        _points,
        %{assigns: %{ship_type: type, ship_orientation: orientation}} = socket
      )
      when is_nil(type) or is_nil(orientation) do
    {:noreply, socket}
  end

  def handle_event("add_ship", %{"x" => x, "y" => y}, socket) do
    {:noreply,
     socket
     |> ships({String.to_integer(x), String.to_integer(y)})
     |> to_points()
     |> ship_type(nil)
     |> game_status()}
  end

  def handle_event("ship_type", %{"type" => ship}, socket) do
    {:noreply, socket |> ship_type(String.to_atom(ship))}
  end

  def handle_event("ship_orientation", %{"orientation" => ship}, socket) do
    {:noreply, socket |> ship_orientation(String.to_atom(ship))}
  end

  defp already_on_board?(ships, type) do
    ships
    |> Enum.any?(fn ship -> ship.type == type end)
  end
end
