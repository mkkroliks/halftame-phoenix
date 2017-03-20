defmodule Halftame.Repo.Migrations.AddDeparturePlaceIdAndReturnPlaceIdToCourierOffer do
  use Ecto.Migration

  def change do
    alter table(:couriers_offers) do
      add :departure_place_id, references(:places)
      add :destination_place_id, references(:places)
    end
  end
end
