defmodule Halftame.CourierOfferView do
  require IEx
  use Halftame.Web, :view

  def render("index.json", %{couriers_offers: couriers_offers}) do
    %{data: render_many(couriers_offers, Halftame.CourierOfferView, "courier_offer.json")}
  end

  def render("show.json", %{courier_offer: courier_offer}) do
    %{data: render_one(courier_offer, Halftame.CourierOfferView, "courier_offer.json")}
  end

  def render("courier_offer.json", %{courier_offer: courier_offer}) do
    IEx.pry
    %{id: courier_offer.id,
      user_id: courier_offer.user_id,
      departure_date: courier_offer.departure_date,
      return_date: courier_offer.return_date}
  end
end
