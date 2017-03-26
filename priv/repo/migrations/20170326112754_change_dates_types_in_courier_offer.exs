defmodule Halftame.Repo.Migrations.ChangeDatesTypesInCourierOffer do
  use Ecto.Migration

  def change do
    alter table(:couriers_offers) do
      remove :departure_date
      remove :return_date
      add :departure_date, :utc_datetime
      add :return_date, :utc_datetime
    end
  end
end
