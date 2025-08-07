defmodule FeedbackWeb.SubmitController do
  use FeedbackWeb, :controller

  alias Feedback.Repo
  alias Feedback.User  # Your Ecto schema

  def submit(conn, %{"feedback" => feedback_params}) do
  feedback_text = feedback_params["feedback"] || ""
  user_id = get_session(conn, :user_id) # Or from params, or conn.assigns.current_user.id

  IO.puts("Session id we got: ")
  IO.puts(user_id)
  feedback_params = Map.put(feedback_params, "user_id", user_id)


  if String.length(feedback_text) > 255 do
    conn
    |> put_flash(:error, "Feedback must be under 255 characters.")
    |> redirect(to: "/feedback/create")
  else
    changeset = User.changeset(%User{}, feedback_params)

    case Repo.insert(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User created successfully")
        |> redirect(to: "/feedback")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Something went wrong. Please check your input.")
        |> redirect(to: "/feedback/create")

      end
  end
end

end
