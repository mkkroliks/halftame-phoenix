defmodule Halftame.Google do

  def autocomplete(input) do
    %{"predictions" => cities} = Google.Apis.Places.autocomplete(input, [language: "pl", components: "country:pl"])
    Enum.map(cities, fn(x) ->  %{name: Map.get(x, "description"),
                                  id: Map.get(x, "place_id")
                                }

                     end)
  end

  def place_details(place_id) do
    response = Google.Apis.Places.Details.details(place_id)

    names = get_in(response, ["result", "address_components"])
    long_name = get_in(List.first(names), ["long_name"])
    lat = get_in(response, ["result", "geometry", "location", "lat"])
    lng = get_in(response, ["result", "geometry", "location", "lng"])

    %{google_id: place_id, name: long_name, latitude: lat, longitude: lng}
  end

end
