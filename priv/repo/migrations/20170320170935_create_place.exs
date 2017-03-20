defmodule Halftame.Repo.Migrations.CreatePlace do
  use Ecto.Migration

  def change do
    create table(:places) do
      add :google_id, :string, null: false
      add :name, :string
      add :latitude, :float
      add :longitude, :float

      timestamps()
    end
    create unique_index(:places, [:google_id])
  end
end
