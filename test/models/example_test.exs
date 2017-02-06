defmodule Halftame.ExampleTest do
  use Halftame.ModelCase

  alias Halftame.Example

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Example.changeset(%Example{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Example.changeset(%Example{}, @invalid_attrs)
    refute changeset.valid?
  end
end
