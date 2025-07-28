defmodule FeedbackWeb.CreateController do
  use FeedbackWeb, :controller

  alias Feedback.User
  # alias Feedback.Repo

  # GET /create
  def create(conn, _params) do
    changeset = User.changeset(%User{}, _params)
    render(conn, :create, changeset: changeset)
  end
end
