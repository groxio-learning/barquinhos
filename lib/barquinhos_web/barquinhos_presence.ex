defmodule Barquinhos.Presence do
  use Phoenix.Presence,
    otp_app: :barquinhos,
    pubsub_server: Barquinhos.PubSub
end
