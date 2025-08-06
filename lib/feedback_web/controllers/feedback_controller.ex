defmodule FeedbackWeb.FeedbackController do
  use FeedbackWeb, :controller
  alias Feedback.NewFeedback
  alias Feedback.Repo

  def greet(conn, _params) do
    render(conn, :greet, layout: false)
  end

# def handle_event("search", %{"first_name" => first_name}, socket) do
#   users =
#     User
#     |> Repo.all()
#     |> Enum.filter(fn user ->
#       String.downcase(user.fname || "")
#       |> String.contains?(String.downcase(first_name))
#     end)

#   {:noreply, assign(socket, first_name: first_name, users: users)}
# end



  def feedback(conn, %{"first_name"=>first_name}) do

    # user = Feedback.Repo.all(from u in Feedback.User, where: ilike(u.fname, ^"%#{first_name}%"))
    #  IO.puts("This is user we get from searching: ")
    # IO.inspect(user)

    user=Feedback.Repo.all(Feedback.User)

   user= Enum.filter(user,fn user -> String.downcase(user.fname || "")
                |> String.contains?(String.downcase(first_name)) end)

    render(conn, :feedback,user: user, first_name: first_name || "")
    end

  ## helps in creation of feedback by a form
     def feedback(conn, _params) do

    user=Feedback.Repo.all(Feedback.User)
    render(conn, :feedback,user: user, first_name: "")
  end


  def newfeedback(conn,_params) do

  changeset = Feedback.NewFeedback.changeset(%Feedback.NewFeedback{}, %{})
  render(conn, :newfeedback, changeset: changeset)

  end

 def submitnew(conn,%{"newfeedback" => feedback_params})do

    IO.puts("What we go from user: ")
    IO.inspect(feedback_params)

    feedback_text = feedback_params["feedback"] || ""

  if String.length(feedback_text) > 255 do
    conn
    |> put_flash(:error, "Feedback must be under 255 characters.")
    |> redirect(to: "/feedbackNewForm")
  else
    changeset = NewFeedback.changeset(%NewFeedback{}, feedback_params)

    case Repo.insert(changeset) do
      {:ok, _newfeedback} ->
        conn
        |> put_flash(:info, "User created successfully")
        |> redirect(to: "/feedback")
        # render(:newfeedback, changeset: changeset)

{:error, changeset} ->
  # render(conn,:newfeedback, changeset: changeset)
    render(conn, :newfeedback, changeset: %{changeset | action: :insert})


    end
  end
end
  def about(conn,_params) do
    render(conn,:about,layout: false)

  end


def contact(conn,_params) do
    render(conn,:contact,layout: false)

  end

   def create(conn, _params) do

    render(conn, :create)
  end


  def delete(conn, %{"id"=>id}) do

    record = Feedback.Repo.get!(Feedback.User, id)
     case Feedback.Repo.delete(record) do

      {:ok,_deleteData} ->
        conn
        |> put_flash(:info, "feedback deleted successfully ")
        |>  redirect(to: "/feedback")

      {:error,_deleteData} ->

        conn
        |> put_flash(:erro, " Error while deleting feedback ")
        |>redirect(to: "/feedback/")


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

  changeset = Feedback.User.changeset(feedback, feedback_params)

  case Feedback.Repo.update(changeset) do
    {:ok, _updated_feedback} ->
      conn
      |> put_flash(:info, "Feedback updated successfully.")
      |> redirect(to: "/feedback")

    {:error, _changeset} ->
       render(conn, :edit, id: id)
  end
end



end
