defmodule Feedback.Repo do
  use Ecto.Repo,
    otp_app: :feedback,
    adapter: Ecto.Adapters.Postgres
end
