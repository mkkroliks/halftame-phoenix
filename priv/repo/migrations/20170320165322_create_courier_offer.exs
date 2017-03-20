defmodule Halftame.Repo.Migrations.CreateCourierOffer do
  use Ecto.Migration

  def change do
    create table(:couriers_offers) do
      add :departure_date, :date
      add :return_date, :date
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:couriers_offers, [:user_id])

  end
end
