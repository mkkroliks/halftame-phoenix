defmodule Halftame.TestHelpers do
  alias Halftame.Repo
  alias Halftame.User
  alias Halftame.Place
  alias Halftame.CourierOffer
  alias Ecto.Multi

  require IEx

  def insert_user(attrs \\ %{}) do
    changes = Dict.merge(%{
      name: "Some User",
      fb_token: "rwer93dkj23@3434",
      photo: "qwe",
      email: "example@gmail.com",
      first_name: "Jan"
    }, attrs)

    %Halftame.User{}
    |> Halftame.User.changeset(changes)
    |> Repo.insert!()
  end

  def insert_place(attrs \\ %{}) do
    changes = Dict.merge(%{
        google_id: "qwoeiu",
        name: "Poznań",
        latitude: 31.231238,
        longitude: 31.23213138
    }, attrs)

    %Halftame.Place{}
    |> Halftame.Place.changeset(changes)
    |> Repo.insert!()
  end
end
