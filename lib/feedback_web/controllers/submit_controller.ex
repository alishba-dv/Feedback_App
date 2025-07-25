defmodule FeedbackWeb.SubmitController do
  use FeedbackWeb, :controller

  alias Feedback.Repo
  alias Feedback.User  # Your Ecto schema

  def submit(conn, %{"feedback" => feedback_params}) do
  feedback_text = feedback_params["feedback"] || ""

  if String.length(feedback_text) > 255 do
    conn
    |> put_flash(:error, "Feedback must be under 255 characters.")
    |> redirect(to: "/feedback/create")
  else
    changeset = User.changeset(%User{}, feedback_params)

    case Repo.insert(changeset) do
      {:ok, _user} ->
        redirect(conn, to: "/feedback/greeting")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Something went wrong. Please check your input.")
        |> redirect(to: "/feedback/create")
    end
  end
end


end
