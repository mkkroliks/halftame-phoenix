defmodule Halftame.GoogleView do
  require IEx
  use Halftame.Web, :view

  def render("cities.json", %{cities: cities}) do
    cities
  end

  def render("city.json", %{city: city}) do
    render_one(city, Halftame.CityView, "city.json")
  end

  def render("city.json", %{city: city}) do
    %{name: city.name,
    #   first_name: user.first_name,
    #   photo: user.photo,
      }
    # city
  end
end
