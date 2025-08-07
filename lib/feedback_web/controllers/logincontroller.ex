defmodule FeedbackWeb.LoginFormController do
  use FeedbackWeb, :controller

  alias Feedback.Repo
  alias Feedback.UserData
def logout(conn,_params) do

   conn
  |> delete_session(:user_id)
  |>put_flash(:info,"Logout successfully ")
  |> redirect(to: "/login")


end
    def loginform(conn,_params) do

      user_id=get_session(conn,:user_id)


      render(conn,:loginform,layout: false)


    end

   def loginuser(conn, %{"user" => user_params}) do

    email = user_params["email"]
  password = user_params["password"]

  users = Repo.all(UserData)

  matched_users = Enum.filter(users, fn user ->
    String.downcase(user.email || "") == String.downcase(email)
  end)

  if matched_users == [] do
    conn
    |> put_flash(:error, "No such user found")
    |> redirect(to: "/login")
  else
    matched_user = hd(matched_users)
    IO.puts("This is matched_user:: ")
    IO.puts(matched_user.id)

   if Bcrypt.verify_pass(password, matched_user.password) do

      conn
      |> put_session(:user_id, matched_user.id)

      |> put_flash(:info, "Login Successful")
      |> redirect(to: "/feedback")
    else
      conn
      |> put_flash(:error, "Wrong password")
      |> redirect(to: "/login")
    end
  end
end


    end
