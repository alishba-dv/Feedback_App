defmodule Feedback.UserData do
  use Ecto.Schema
  import Ecto.Changeset

  schema "userdatas" do
    field :email, :string
    field :name, :string
    field :password, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_data, attrs) do
    user_data
    |> cast(attrs, [:name, :password, :email])
    |> validate_required([:name, :password, :email])
  end
end
