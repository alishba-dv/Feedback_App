defmodule FeedbackWeb.SignUpController do
  use FeedbackWeb, :controller
  alias Feedback.Repo
  alias Feedback.UserData

  def signup(conn,_params) do


    render(conn,:signup,layout: false)

  end

  def signupuser(conn,%{"user"=>user}) do
    name=user["name"]
    email=user["email"]
    password=user["password"]

    hashedpassword=Bcrypt.hash_pwd_salt(password)
    user = %{
  "name" => name,
  "email" => email,
  "password" => hashedpassword
}
    changeset=UserData.changeset(%UserData{},user)

    case Repo.insert(changeset) do

        {:ok,_userdata} ->
          conn
          |>put_flash(:info,"SignUp Successful")
          |>redirect(to: "/feedback")

        {:error,_message} ->
            conn
            |>put_flash(:error,"Error Signup: ")
            |> redirect(to: "/signup")

    end

    render(conn,:signupuser,layout: false)
  end

end
