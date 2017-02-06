defmodule Halftame.Repo.Migrations.CreateExample do
  use Ecto.Migration

  def change do
    create table(:examples) do
      add :name, :string

      timestamps()
    end

  end
end
