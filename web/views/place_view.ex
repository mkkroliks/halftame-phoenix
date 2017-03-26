defmodule Halftame.PlaceView do
  require IEx
  use Halftame.Web, :view

  def render("index.json", %{place: place}) do
    %{data: render_many(place, Halftame.PlaceView, "place.json")}
  end

  def render("show.json", %{place: place}) do
    %{data: render_one(place, Halftame.PlaceView, "place.json")}
  end

  def render("place.json", %{place: place}) do
    %{id: place.id,
      google_id: place.google_id,
      name: place.name,
      latitude: place.latitude,
      longitude: place.longitude}
  end

  def display(place: place) do
    %{id: place.id,
      google_id: place.google_id,
      name: place.name,
      latitude: place.latitude,
      longitude: place.longitude}
  end
end
