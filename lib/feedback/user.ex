defmodule Feedback.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :feedback, :string
    field :fname, :string
    field :lname, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:fname, :lname, :email, :feedback])
    |> validate_required([:fname, :lname, :email])

  end
end
