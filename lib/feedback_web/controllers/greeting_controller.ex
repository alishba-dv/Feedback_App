defmodule FeedbackWeb.GreetingController do
  use FeedbackWeb, :controller
  # import Feedback.Repo
  # import Feedback.User

  def greet(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.

    render(conn, :greet, layout: false)
  end


  ## helps in creation of feedback by a form


end
