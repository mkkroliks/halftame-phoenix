defmodule Halftame.CourierOfferTest do
  use Halftame.ModelCase

  alias Halftame.CourierOffer

  @valid_attrs %{departure_date: %{day: 17, month: 4, year: 2010}, return_date: %{day: 17, month: 4, year: 2010}}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CourierOffer.changeset(%CourierOffer{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CourierOffer.changeset(%CourierOffer{}, @invalid_attrs)
    refute changeset.valid?
  end
end
