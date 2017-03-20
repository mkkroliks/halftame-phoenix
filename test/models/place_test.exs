defmodule Halftame.PlaceTest do
  use Halftame.ModelCase

  alias Halftame.Place

  @valid_attrs %{google_id: "some content", latitude: "120.5", longitude: "120.5", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Place.changeset(%Place{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Place.changeset(%Place{}, @invalid_attrs)
    refute changeset.valid?
  end
end
