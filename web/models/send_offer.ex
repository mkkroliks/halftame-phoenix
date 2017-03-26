defmodule Halftame.SendOffer do
  use Halftame.Web, :model

  schema "send_offers" do
    belongs_to :user, Halftame.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end
