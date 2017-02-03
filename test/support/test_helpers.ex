defmodule Halftame.TestHelpers do
  alias Halftame.Repo

  def insert_user(attrs \\ %{}) do
    changes = Dict.merge(%{
      name: "Some User",
      token: "rwer93dkj23@3434"
    }, attrs)

    %Halftame.User{}
    |> Halftame.User.changeset(changes)
    |> Repo.insert!()
  end

  # def insert_video(user, attrs \\ %{}) do
  #   user
  #   |> Ecto.build_assoc(:videos, attrs)
  #   |> Repo.insert!()
  # end
end
