defmodule Barquinhos.Game.Player do
  alias Barquinhos.Game.Board
  defstruct [:id, :nickname, ready: false, winner: false, lose: false, board: %Board{}, shots: []]

  def new do
    %__MODULE__{
      id: generate_id()
    }
  end

  def new(%{id: id, ready: ready, lose: lose} = _attrs) do
    %__MODULE__{
      id: id,
      ready: ready,
      lose: lose
    }
  end

  def add_shot(player, shot) do
    %{player | shots: [shot | player.shots]}
  end

  defp generate_id(), do: Enum.random(1000..9999)
end
