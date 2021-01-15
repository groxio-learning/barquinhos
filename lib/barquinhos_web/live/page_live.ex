defmodule BarquinhosWeb.PageLive do
  use BarquinhosWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, player: nil)}
  end

  defp play(socket) do
    socket
    |> push_redirect(to: "/game/")
  end

  def handle_event("play", _params, socket) do
    {:noreply, socket |> play}
  end
end
