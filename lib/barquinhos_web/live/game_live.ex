defmodule BarquinhosWeb.GameLive do
  use BarquinhosWeb, :live_view
  alias Barquinhos.Game.{Board, Ship, Player}
  alias Barquinhos.Presence

  def mount(_params, _session, socket) do
    player = Player.new()

    if connected?(socket) do
      BarquinhosWeb.Endpoint.subscribe("battleship")
      Presence.track(self(), "battleship", player.id, %{id: player.id, ready: player.ready})
    end

    {:ok, socket |> build(player)}
  end

  def build(socket, player) do
    socket
    |> players()
    |> player(player)
    |> ships()
    |> board()
    |> points()
    |> shots()
    |> shots_received()
    |> ship_type(nil)
    |> ship_orientation(nil)
    |> game_status(:placing)
    |> every_player_ready()
  end

  def every_player_ready(socket) do
    assign(socket, every_player_ready: false)
  end

  defp players(socket) do
    assign(socket, players: [])
  end

  defp player(socket, player) do
    assign(socket, player: player)
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

  defp game_status(%{assigns: %{player: player, ships: ships}} = socket)
       when length(ships) == 5 do
    Presence.update(self(), "battleship", player.id, %{player | ready: true})
    assign(socket, game_status: :ready)
  end

  defp game_status(socket), do: socket

  def all_players_ready?([]), do: false

  #for all of the players, take each player and check to see if it's ready
  def all_players_ready?(players) do
    Enum.all?(players, fn player -> player.ready end)
  end

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
    if all_players_ready?(socket.assigns.players) do
      BarquinhosWeb.Endpoint.broadcast("battleship", "shot_fired", %{
        "player" => socket.assigns.player,
        "x" => x,
        "y" => y
      })

      {:noreply,
       assign(socket, shots: [{String.to_integer(x), String.to_integer(y)} | socket.assigns.shots])}
     else
       {:noreply, socket}
     end
  end

  def handle_event("ship_type", %{"type" => ship}, socket) do
    {:noreply, socket |> ship_type(String.to_atom(ship))}
  end

  def handle_event("ship_orientation", %{"orientation" => ship}, socket) do
    {:noreply, socket |> ship_orientation(String.to_atom(ship))}
  end

  def handle_info(
        %Phoenix.Socket.Broadcast{
          event: "shot_fired",
          payload: %{"player" => player, "x" => x, "y" => y},
          topic: "battleship"
        },
        socket
      ) do
    IO.puts("shots fired!")

    if player.id != socket.assigns.player.id do
      {:noreply,
       assign(socket,
         shots_received: [
           {String.to_integer(x), String.to_integer(y)} | socket.assigns.shots_received
         ]
       )}
    else
      {:noreply, socket}
    end
  end

  def handle_info(%Phoenix.Socket.Broadcast{event: "presence_diff"}, socket) do
    IO.puts("presence diff event!")
    players = for {_id, %{metas: [player]}} <- Presence.list("battleship"), do: Player.new(player)
    {:noreply, assign(socket, players: players)}
  end

  defp already_on_board?(ships, type) do
    ships
    |> Enum.any?(fn ship -> ship.type == type end)
  end

  defp ship_class(points, {x, y}) do
    if "#{x}#{y}" in points, do: "ship"
  end

  defp shot_class(shots_received, points, {x, y}) do
    cond do
      {x, y} in shots_received && "#{x}#{y}" in points -> "hit"
      {x, y} in shots_received -> "shot"
      true -> ""
    end
  end
end
