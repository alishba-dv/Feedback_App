defmodule Feedback.NewFeedback do
  use Ecto.Schema
  import Ecto.Changeset
  schema "newfeedback" do
    field :age, :integer
    field :email, :string
    field :feedback, :string
    field :fname, :string
    field :lname, :string
    field :phone, :string
    field :status, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(new_feedback, attrs) do
    new_feedback
    |> cast(attrs, [:feedback, :fname, :lname, :email, :age, :phone, :status])
    |> validate_required([:feedback, :fname, :lname, :email, :age, :phone, :status])
    |>validate_inclusion(:status, ["active","inactive"],message: "Status can be either active or inactive ")
    |> validate_format(:phone,~r/^0?3(?:[0-46]\d|55)\d{7}$/,message: "Phone number must follow format: 03XXXXXXXXX")
    # |> validate_format(:email,~r/^[a-zA-Z0–9. _%+-]+@[a-zA-Z0–9. -]+\. [a-zA-Z]{2,}$/,message: "Email is invalid")
    |>validate_format(:email,~r/@/)
    |>validate_number(:age,greater_than_or_equal_to: 18,message: "Age must be greater than or equal to")
    # |>validate_length(:password,min: 8,message: "Password must be 8 characters long")
    # |>validate_format(:password,~r/[A-Z]/,message: "Password must contain at least one upper case character")
    # |>validate_format(:password,~r/[a-z]/,message: "Password must contain at least one lower case character")
    # |>validate_format(:password,~r/\d/,message: "Password must contain at least one digit")
    # |>validate_format(:password,~r/[!@#$%&*]/,message: "Password must contain at least one special character")
  end
end
