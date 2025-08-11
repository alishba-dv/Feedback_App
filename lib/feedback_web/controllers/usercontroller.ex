defmodule FeedbackWeb.UserController do
  use FeedbackWeb, :controller
  alias Feedback.NewFeedback
  alias Feedback.Repo
  alias Feedback.UserData
import Ecto.Query


# ===========================
# ===========================

  use PhoenixSwagger



swagger_path :getusers do
    get("/api/users")
    summary("List all users")
    description("Fetches all users from the database")
    produces "application/json"
    response 200, "Success", Schema.ref(:users)
    response 400, "bad request"
  end



 swagger_path :create_user do
  post("/api/users")
  summary("Add a new user")
  description("Adds a new user in the database")
  consumes "application/json"
  produces "application/json"
  parameters do
    user :body, Schema.ref(:create_user), "User details", required: true
  end
  response 201, "Created", Schema.ref(:users)
  response 400, "Bad Request"
end


swagger_path :delete_user do
  delete("/api/users")
  summary("Delete a user")
  description("Deletes  a  user in the database")
  consumes "application/json"
  produces "application/json"
  parameters do
    user :body, Schema.ref(:delete_user), "User ID", required: true
  end
  response 201, "Created", Schema.ref(:delete_user)
  response 400, "Bad Request"
end


 swagger_path :update_user do
  patch("/api/users")
  summary("Updates an existing user")
  description("Updates a user in database")
  consumes "application/json"
  produces "application/json"
  parameters do
    user :body, Schema.ref(:update_user), "User details", required: true
  end
  response 201, "Created", Schema.ref(:users)
  response 400, "Bad Request"
end



def swagger_definitions do
  %{
    users: swagger_schema do
      title "View Users"
      description "A user"
      properties do
        id :integer, "ID", required: true
        email :string, "Email"
        name :string, "First name"
      end

    end,
    create_user: swagger_schema do
      title "Create User"
      description "Schema for creating a new user"
      properties do
        email :string, "Email", required: true
        name :string, "First name", required: true
        password :string, "Password", required: true
      end
      example %{

        email: "new@example.com",
        name: "New User",
        password: "newpassword123@"
      }
    end,
    delete_user: swagger_schema do
      title "Delete User"
      description "A user"
      properties do
        id :integer, "id", required: true

      end
      example %{
        id: 3,

      }
    end,
    update_user: swagger_schema do
      title "Updates User"
      description "Schema for updpating a new user"
      properties do
        id :integer, "ID", required: true
        email :string, "Email", required: true
        name :string, "Name", required: true
        password :string, "Password", required: true
      end
        example %{
        id: 3,
        email: "updated@example.com",
        name: "Updated Name",
        password: "newpassword123"
      }
    end,

  }
end



  ## helps in fetching of feedback by a form
  def getusers(conn, _params) do
  user_id = get_session(conn, :user_id)
  if user_id == nil do
    render(conn, :loginrequired, message: "You must be logged in to view feedbacks")
  end

  user = Feedback.Repo.all(Feedback.User)
  json(conn, %{data: user, message: "Feedback fetched successfullly"})
end


 def create_user(conn, params) do

  changeset = UserData.changeset(%UserData{}, params)

  if changeset.valid?() do
    hashed_password = Bcrypt.hash_pwd_salt(params["password"])
    updated_params = Map.put(params, "password", hashed_password)
    final_changeset = UserData.changeset(%UserData{}, updated_params)

    case Repo.insert(final_changeset) do
      {:ok, user_data} ->
        json(conn, %{data: user_data, message: "User created successfully"})
      {:error, changeset} ->
        # Return validation errors in JSON or render a template
        json(conn, %{errors: changeset_errors(changeset)})
    end
  else
    json(conn, %{errors: changeset_errors(changeset)})
  end
end

defp changeset_errors(changeset) do
  Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
    # customize errors if needed
    Phoenix.Naming.humanize(msg)
  end)
end



def delete_user(conn, %{"id" => id}) do
  case Repo.get(Feedback.UserData, id) do
    nil ->
      conn
      |> put_status(:not_found)
      |> json(%{error: "User not found"})
    user ->
      case Repo.delete(user) do
        {:ok, _struct} ->
          json(conn, %{message: "User deleted successfully"})
        {:error, _changeset} ->
          conn
          |> put_status(:internal_server_error)
          |> json(%{error: "Failed to delete user"})
      end
  end
end


 def update_user(conn, params) do
  # Extract id from params
  id = params["id"]

  case Repo.get(Feedback.UserData, id) do
    nil ->
      send_resp(conn, 404, "User not found")

    user ->
      # Remove id from params before changeset to avoid conflicts
      user_params = Map.delete(params, "id")

      changeset = Feedback.UserData.changeset(user, user_params)

      case Repo.update(changeset) do
        {:ok, updated_user} ->
          json(conn, %{data: updated_user, message: "User updated successfully"})

        {:error, changeset} ->
          conn
          |> put_status(:bad_request)
          |> json(%{errors: changeset})
      end

end

end



  # ===========================





  def feedback(conn, %{"first_name"=>first_name}) do



    user=Feedback.Repo.all(Feedback.User)

   user= Enum.filter(user,fn user -> String.downcase(user.fname || "")
                |> String.contains?(String.downcase(first_name)) end)

    render(conn, :feedback,user: user, first_name: first_name || "")
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
    user_id=get_session(conn,:user_id)
      if(user_id==nil) do
          render(conn,:loginrequired,message: "You must be logged in to create a  feedback")
      end

    render(conn, :create)
  end





  def edit(conn,%{"id"=> id}) do

    ##get all data frmo db
      record=Feedback.Repo.get!(Feedback.User, id)
    render(conn,:edit,id: id,feedback: record)

  end

def userfeedback(conn, _params) do

  id=get_session(conn,:user_id)
user =
    from(f in Feedback.User, offset: 1, where: f.user_id == ^id )
    |> Feedback.Repo.all()
    IO.puts("user got from id:::")
  IO.inspect(user)

    render(conn, :userfeedback,user: user, first_name: "")
  end
def getfeedbackbyid(conn,%{"id" => id}) do

  # feedback = Feedback.Repo.get!(Feedback.User, "user_id" => id)

feedback =
    from(f in Feedback.User, where: f.user_id == ^id)
    |> Feedback.Repo.all()

    IO.puts("Feedback got from id:::")
  IO.inspect(feedback)
      user=Feedback.Repo.all(Feedback.User)


  render(conn,:getfeedbackbyid,user: user,feedback: List.wrap(feedback), first_name: "")


end




def loginrequired(conn,_params) do



  render(conn,:loginrequired,layout: false)

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
