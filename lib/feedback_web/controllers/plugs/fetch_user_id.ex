defmodule FeedbackWeb.Plugs.FetchUserId do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    conn=fetch_session(conn)
    name = get_session(conn, :fname)

     conn
  |> assign(:name, name)
  |> assign(:user_id, get_session(conn, :user_id))

  end
end
