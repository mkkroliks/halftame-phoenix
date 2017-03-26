defmodule Halftame.CourierOffer do
  require IEx
  use Halftame.Web, :model

  schema "couriers_offers" do
    field :departure_date, Ecto.DateTime
    field :return_date, Ecto.DateTime
    belongs_to :user, Halftame.User
    has_one :departure_place, Halftame.Place
    has_one :destination_place, Halftame.Place
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do

    c_departure_date = DateTime.from_unix!(params["departure_date"])
    c_return_date = DateTime.from_unix!(params["return_date"])

    params = %{departure_date: c_departure_date, return_date: c_return_date}

    struct
    |> cast(params, [:departure_date, :return_date])
    |> validate_required([:departure_date, :return_date])
  end

  def toUnix(date) do
    {:ok, date_time} = date |> Ecto.DateTime.to_erl |> NaiveDateTime.from_erl! |> DateTime.from_naive("Etc/UTC")
    DateTime.to_unix(date_time)
  end
end
