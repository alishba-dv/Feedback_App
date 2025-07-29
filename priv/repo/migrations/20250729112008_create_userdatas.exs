defmodule Feedback.Repo.Migrations.CreateUserdatas do
  use Ecto.Migration

  def change do
    create table(:userdatas) do
      add :name, :string
      add :password, :string
      add :email, :string

      timestamps(type: :utc_datetime)
    end
  end
end
