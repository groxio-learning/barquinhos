defmodule Barquinhos.Game.Player do
  alias Barquinhos.Game.Board
  defstruct [:id, :nickname, winner: false, board: %Board{size: {}}, shots: []]

  def new(nickname) do
    %__MODULE__{
      id: generate_id(),
      nickname: nickname
    }
  end

  def add_shot(player, shot) do
    %{player | shots: [shot | player.shots]}
  end

  defp generate_id(), do: Enum.random(1000..9999)
end
