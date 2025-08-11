defmodule Feedback.User do
  use Ecto.Schema
  import Ecto.Changeset
  @derive {Jason.Encoder, only: [:id, :email, :fname, :lname, :feedback]}

  schema "users" do
    field :email, :string
    field :feedback, :string
    field :fname, :string
    field :lname, :string
    # field :user_id, :id

    ## here is an association --> a feedback must belongs to a user
      belongs_to :userdatas, Feedback.UserData, foreign_key: :user_id
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:fname, :lname, :email, :feedback, :user_id])
    |> validate_required([:fname, :lname, :email, :user_id])
    # |> unique_constraint(:email)

    # |>validate_length(:password,min: 8,message: "Password must be 8 characters long")
    # |>validate_format(:password,~r/[A-Z]/,message: "Password must contain at least one upper case character")
    # |>validate_format(:password,~r/[a-z]/,message: "Password must contain at least one lower case character")
    # |>validate_format(:password,~r/\d/,message: "Password must contain at least one digit")
    # |>validate_format(:password,~r/[!@#$%&*]/,message: "Password must contain at least one special character")
  end
end
