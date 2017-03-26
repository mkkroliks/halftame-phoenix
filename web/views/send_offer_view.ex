defmodule Halftame.SendOfferView do
  use Halftame.Web, :view

  def render("index.json", %{send_offers: send_offers}) do
    %{data: render_many(send_offers, Halftame.SendOfferView, "send_offer.json")}
  end

  def render("show.json", %{send_offer: send_offer}) do
    %{data: render_one(send_offer, Halftame.SendOfferView, "send_offer.json")}
  end

  def render("send_offer.json", %{send_offer: send_offer}) do
    %{id: send_offer.id,
      user_id: send_offer.user_id}
  end
end
