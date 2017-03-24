defmodule Halftame.Repo.Migrations.RemoveUniqueKeyFromPlace do
  use Ecto.Migration

  def change do
    drop unique_index(:places, [:google_id])
  end
end
