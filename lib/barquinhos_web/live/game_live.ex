defmodule BarquinhosWeb.GameLive do
  use BarquinhosWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket |> build}
  end

  def build(socket) do
    socket
    |> ships()
  end

  defp ships(socket) do
    assign(socket, ships: [])
  end

  defp ships(%{assigns: %{ships: ships}} = socket, ship) do
    assign(socket, ships: [ship | ships])
  end

  def handle_event("slot", %{"x" => x, "y" => y}, socket) do
    IO.inspect({x, y})
    {:noreply, socket |> ships(x <> y)}
  end

end
