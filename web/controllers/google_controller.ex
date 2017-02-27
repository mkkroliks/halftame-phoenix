defmodule Halftame.GoogleController do
  require IEx
  use Halftame.Web, :controller

  def cities(conn, %{"input" => input}) do
    cities = Halftame.Google.autocomplete(input)
    render(conn, "cities.json", cities: cities)
  end

end
