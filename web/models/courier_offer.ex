defmodule Halftame.CourierOffer do
  use Halftame.Web, :model

  schema "couriers_offers" do
    field :departure_date, Ecto.Date
    field :return_date, Ecto.Date
    belongs_to :user, Halftame.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:departure_date, :return_date])
    |> validate_required([:departure_date, :return_date])
  end
end
