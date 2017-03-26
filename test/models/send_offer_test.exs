defmodule Halftame.SendOfferTest do
  use Halftame.ModelCase

  alias Halftame.SendOffer

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = SendOffer.changeset(%SendOffer{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = SendOffer.changeset(%SendOffer{}, @invalid_attrs)
    refute changeset.valid?
  end
end
