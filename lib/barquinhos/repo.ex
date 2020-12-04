defmodule Barquinhos.Repo do
  use Ecto.Repo,
    otp_app: :barquinhos,
    adapter: Ecto.Adapters.Postgres
end
