defmodule FeedbackWeb.Plugs.FetchUserId do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
     conn
  # |> assign(:fname, fetch_session(conn, :fname))
  |> assign(:user_id, fetch_session(conn, :user_id))

  end
end
