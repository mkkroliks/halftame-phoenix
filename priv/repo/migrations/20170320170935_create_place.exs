defmodule Halftame.Repo.Migrations.CreatePlace do
  use Ecto.Migration

  def change do
    create table(:places) do
      add :google_id, :string
      add :name, :string
      add :latitude, :float
      add :longitude, :float

      timestamps()
    end

  end
end
