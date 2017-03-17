defmodule Halftame.Google do

  def autocomplete(input) do
    %{"predictions" => cities} = Google.Apis.Places.autocomplete(input, [language: "pl", components: "country:pl"])
    Enum.map(cities, fn(x) ->  %{name: Map.get(x, "description"),
                                  id: Map.get(x, "place_id")
                                }

                     end)
  end

end
