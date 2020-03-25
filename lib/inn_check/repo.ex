defmodule InnCheck.Repo do
  use Ecto.Repo,
    otp_app: :inn_check,
    adapter: Ecto.Adapters.Postgres
end
