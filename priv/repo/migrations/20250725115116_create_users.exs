defmodule Feedback.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :fname, :string
      add :lname, :string
      add :email, :string
      add :feedback, :string, size: 255

      timestamps(type: :utc_datetime)
    end
  end
end
