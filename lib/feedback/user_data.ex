defmodule Feedback.UserData do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_datas" do
    field :email, :string
    field :name, :string
    field :password, :string

    ##here is an association of "a user can have many feedbacks-->users"

    timestamps(type: :utc_datetime)
  end

@doc false
def changeset(user_datas, attrs) do
  user_datas
  |> cast(attrs, [:email, :name, :password])
  |> validate_required([:email, :name, :password])
  |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must be a valid email")
  |> unique_constraint(:email, message: "Email already taken")
  |> validate_password()
end

defp validate_password(changeset) do
  changeset
  |> validate_length(:password, min: 8, message: "Password must be at least 8 characters long")
  |> validate_format(:password, ~r/[A-Z]/, message: "Must contain a uppercase letter, a lower case letter and a digit")
  |> validate_format(:password, ~r/[a-z]/, message: "Must contain a uppercase letter, a lower case letter and a digit")
  |> validate_format(:password, ~r/\d/, message: "Must contain a uppercase letter, a lower case letter and a digit")
  |> validate_format(:password, ~r/[!@#$%^&*()_+{}\[\]:;<>,.?~\\\-]/, message: "Must contain special character")
end


end
