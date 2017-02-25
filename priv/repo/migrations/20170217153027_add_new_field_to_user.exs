defmodule Halftame.Repo.Migrations.AddNewFieldToUser do
  use Ecto.Migration

  def change do
    rename table(:users), :name, to: :first_name

    alter table(:users) do
      remove :token
      add :email, :string
      add :photo, :text
      add :fb_token, :text
    end
  end
end
