defmodule BarquinhosWeb.GameLive do
  use BarquinhosWeb, :live_view
  alias Barquinhos.Game.Board

  def mount(_params, _session, socket) do
    {:ok, socket |> build}
  end

  def build(socket) do
    socket
    |> ships()
    |> board()
  end

  defp ships(socket) do
    assign(socket, ships: [])
  end

  defp board(socket) do
    assign(socket, board: Board.new)
  end

  defp ships(%{assigns: %{ships: ships}} = socket, ship) do
    assign(socket, ships: [ship | ships])
  end

  def handle_event("slot", %{"x" => x, "y" => y}, socket) do
    IO.inspect({x, y})
    {:noreply, socket |> ships(x <> y)}
  end
end
