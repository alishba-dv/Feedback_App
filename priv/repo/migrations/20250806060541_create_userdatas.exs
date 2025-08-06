defmodule Feedback.Repo.Migrations.CreateUserdatas do
  use Ecto.Migration

  def change do
    create table(:userdatas) do
      add :email, :string
      add :name, :string
      add :password, :string
    add :user_id, references(:userdatas, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

        create unique_index(:userdatas, [:email])  # move it outside the table block

  end
end
