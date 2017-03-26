defmodule Halftame.CourierOfferView do
  require IEx
  use Halftame.Web, :view

  def render("index.json", %{couriers_offers: couriers_offers}) do
    %{data: render_many(couriers_offers, Halftame.CourierOfferView, "courier_offer.json")}
  end

  def render("show.json", %{courier_offer: courier_offer}) do
    render_one(courier_offer, Halftame.CourierOfferView, "courier_offer.json")
  end

  def render("courier_offer.json", %{courier_offer: courier_offer}) do
    %{id: courier_offer.id,
      user: Halftame.UserView.display(user: courier_offer.user),
      destination_place: Halftame.PlaceView.display(place: courier_offer.destination_place),
      departure_place: Halftame.PlaceView.display(place: courier_offer.departure_place),
      departure_date: courier_offer.departure_date,
      return_date: courier_offer.return_date}
  end

  def render("error.json", %{message: message}) do
    %{message: message}
  end
end
