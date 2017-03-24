defmodule Halftame.Repo.Migrations.AddCourierOfferIdindexToPlace do
  use Ecto.Migration

  def change do

    alter table(:places) do
      add :courier_offer_id, references(:couriers_offers)
    end
    create index(:places, [:courier_offer_id])
  end
end
