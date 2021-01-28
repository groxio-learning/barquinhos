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
  end

  defp ships(socket) do
    assign(socket, ships: [])
  end

  defp points(socket) do
    assign(socket, points: [])
  end

  defp board(socket) do
    assign(socket, board: Board.new)
  end

  defp ships(%{assigns: %{ships: ships}} = socket, ship) do
    assign(socket, ships: [new_ship(ship) | ships])
  end

  defp new_ship(points) do
    Ship.new(points, :vertical, :destroyer)
  end

  defp to_points(%{assigns: %{ships: ships}} = socket) do
    my_ships =
      ships
      |> Enum.map(& Ship.to_points/1)
      |> List.flatten()
      |> Enum.map(fn {x, y} -> "#{x}#{y}" end)
      
    assign(socket, points: my_ships)
  end

  def handle_event("add_ship", %{"x" => x, "y" => y}, socket) do
    {:noreply, socket |> ships({String.to_integer(x), String.to_integer(y)}) |> to_points()}
  end

end
