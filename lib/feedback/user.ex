defmodule Feedback.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :feedback, :string
    field :fname, :string
    field :lname, :string

    ## here is an association --> a feedback must belongs to a user

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:fname, :lname, :email, :feedback])
    |> validate_required([:fname, :lname, :email])
    #     |> unique_constraint(:email)

    # |>validate_length(:password,min: 8,message: "Password must be 8 characters long")
    # |>validate_format(:password,~r/[A-Z]/,message: "Password must contain at least one upper case character")
    # |>validate_format(:password,~r/[a-z]/,message: "Password must contain at least one lower case character")
    # |>validate_format(:password,~r/\d/,message: "Password must contain at least one digit")
    # |>validate_format(:password,~r/[!@#$%&*]/,message: "Password must contain at least one special character")
  end
end
