defmodule Feedback.Repo.Migrations.AddUserIdToUsers do
  use Ecto.Migration

   def change do

    alter table(:users) do
    add :user_id, references(:userdatas, on_delete: :delete_all)

  end
end
end
