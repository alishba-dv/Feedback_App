defmodule FeedbackWeb.SignUpController do
  use FeedbackWeb, :controller
  alias Feedback.Repo
  alias Feedback.UserData

  def signup(conn, _params) do
  changeset = UserData.changeset(%UserData{}, %{})  # empty changeset
  render(conn, :signup, changeset: changeset)
end


  def signupuser(conn,%{"user"=>user}) do
    name=user["name"]
    email=user["email"]
    password=user["password"]
    changeset=UserData.changeset(%UserData{},user)

    if changeset.valid?()  do
    hashedpassword=Bcrypt.hash_pwd_salt(password)

      user = %{
  "name" => name,
  "email" => email,
  "password" => hashedpassword
}

  end


    case Repo.insert(changeset) do

        {:ok,_userdata} ->


          conn
          |>put_flash(:info,"SignUp Successful")
          |>redirect(to: "/feedback")

        {:error,changeset} ->
            # conn
            # |>put_flash(:error,"Error Signup: ")
            # |> redirect(to: "/signup")


            render(conn,:signup,changeset: %{changeset | action: :insert})

    end

    render(conn,:signupuser,layout: false)
  end

end
