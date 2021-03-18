defmodule BarquinhosWeb.GameLive do
  use BarquinhosWeb, :live_view
  alias Barquinhos.Game.{Board, Ship, Player}

  def mount(_params, _session, socket) do
    BarquinhosWeb.Endpoint.subscribe("battleship")
    {:ok, socket |> build}
  end

  def build(socket) do
    socket
    |> player()
    |> ships()
    |> board()
    |> points()
    |> shots()
    |> shots_received()
    |> ship_type(nil)
    |> ship_orientation(nil)
    |> game_status(:placing)
  end

  defp player(socket) do
    assign(socket, player: Player.new("Mickey"))
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

  defp shots(socket) do
    assign(socket, shots: [])
  end

  defp shots_received(socket) do
    assign(socket, shots_received: [])
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
    assign(socket, game_status: :ready, shots: [{2, 7}])
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

  def handle_event("add_shot", %{"x" => x, "y" => y}, socket) do
    BarquinhosWeb.Endpoint.broadcast("battleship", "shot_fired", %{ "player" => socket.assigns.player, "x" => x, "y" => y})
    {:noreply, assign(socket,shots: [{String.to_integer(x), String.to_integer(y)}|socket.assigns.shots])}
  end

  def handle_event("ship_type", %{"type" => ship}, socket) do
    {:noreply, socket |> ship_type(String.to_atom(ship))}
  end

  def handle_event("ship_orientation", %{"orientation" => ship}, socket) do
    {:noreply, socket |> ship_orientation(String.to_atom(ship))}
  end

  def handle_info(%Phoenix.Socket.Broadcast{event: "shot_fired", payload: %{"player" => player, "x" => x, "y" => y}, topic: "battleship"}, socket) do
    IO.puts("shots fired!")
    if player.id != socket.assigns.player.id do
      {:noreply, assign(socket,shots_received: [{String.to_integer(x), String.to_integer(y)}|socket.assigns.shots_received])}
    else
      {:noreply, socket}
    end
  end

  defp already_on_board?(ships, type) do
    ships
    |> Enum.any?(fn ship -> ship.type == type end)
  end

  defp ship_class(points, {x, y}) do
    if "#{x}#{y}" in points, do: "ship"
  end

  defp shot_class(shots, {x, y}) do
    if {x, y} in shots, do: "shot"
  end

end
