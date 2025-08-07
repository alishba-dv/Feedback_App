defmodule FeedbackWeb.SignUpController do
  use FeedbackWeb, :controller

  alias Feedback.Repo
  alias Feedback.UserData

  def signup(conn, _params) do
    changeset = UserData.changeset(%UserData{}, %{})  # Empty changeset
    render(conn, :signup, changeset: changeset)
  end

  def signupuser(conn, %{"user" => user_params}) do
    # Initial validation
    changeset = UserData.changeset(%UserData{}, user_params)

    if changeset.valid?() do
      # Hash the password only if valid
      hashed_password = Bcrypt.hash_pwd_salt(user_params["password"])

      updated_params = Map.put(user_params, "password", hashed_password)

      final_changeset = UserData.changeset(%UserData{}, updated_params)

      case Repo.insert(final_changeset) do
        {:ok, _userdata} ->
          conn
          |> put_flash(:info, "SignUp Successful")
          |> redirect(to: "/feedback")

        {:error, changeset} ->
          # Return form with errors
          render(conn, :signup, changeset: %{changeset | action: :insert})
      end
    else
      # Don't try to insert if invalid
      render(conn, :signup, changeset: %{changeset | action: :insert})
    end
  end
end
defmodule Feedback.Repo.Migrations.AddUserIdToUsers do
  use Ecto.Migration

  def change do

  end
end
