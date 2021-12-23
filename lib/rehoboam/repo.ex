defmodule Rehoboam.Repo do
  use Ecto.Repo,
    otp_app: :rehoboam,
    adapter: Ecto.Adapters.Postgres
end
