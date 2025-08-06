defmodule Feedback.Repo.Migrations.CreateNewfeedback do
  use Ecto.Migration

  def change do
    create table(:newfeedback) do
      add :newfeedbacks, :string
      add :firstname, :string
      add :lastname, :string
      add :email, :string
      add :age, :integer
      add :phone, :string
      add :feedback, :string
      add :status, :string

      timestamps(type: :utc_datetime)
    end
  end
end
