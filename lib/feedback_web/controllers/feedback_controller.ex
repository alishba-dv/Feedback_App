defmodule FeedbackWeb.FeedbackController do
  use FeedbackWeb, :controller
  # import Feedback.Repo
  # import Feedback.User
  alias Feedback.Accounts.User

  def feedback(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
user=Feedback.Repo.all(Feedback.User)


    render(conn, :feedback,user: user)
  end


  ## helps in creation of feedback by a form


  def delete(conn, %{"id"=>id}) do
    # The home page is often custom made,
    # so skip the default app layout.
    record = Feedback.Repo.get!(Feedback.User, id)
     case Feedback.Repo.delete(record) do

      {:ok,_deleteData} ->
        conn
        |> put_flash(:info, "feedback deleted successfully ")
        |>  redirect(to: "/feedback")


     end

    # render(conn, :delete,userid: id)
    # redirect(conn,to: "/feedback")
  end


  def edit(conn,%{"id"=> id}) do

    ##get all data frmo db
      record=Feedback.Repo.get!(Feedback.User, id)
    render(conn,:edit,id: id,feedback: record)

  end



   def update(conn, %{"id" => id, "feedback" => feedback_params}) do
  feedback = Feedback.Repo.get!(Feedback.User, id)

  _changeset = Feedback.User.changeset(feedback, feedback_params)

  case Feedback.Repo.update(_changeset) do
    {:ok, _updated_feedback} ->
      conn
      |> put_flash(:info, "Feedback updated successfully.")
      |> redirect(to: "/feedback")

    {:error, _changeset} ->
      render(conn, FeedbackController,:update, id: id)
  end
end



end
