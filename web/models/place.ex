defmodule Halftame.Place do
  use Halftame.Web, :model

  schema "places" do
    field :google_id, :string
    field :name, :string
    field :latitude, :float
    field :longitude, :float

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:google_id, :name, :latitude, :longitude])
    |> validate_required([:google_id, :name, :latitude, :longitude])
  end
end
