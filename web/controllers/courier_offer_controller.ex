defmodule Halftame.CourierOfferController do
  use Halftame.Web, :controller

  alias Ecto.Multi

  require IEx

  alias Halftame.CourierOffer
  alias Halftame.User
  alias Halftame.Place

  def index(conn, _params) do
    couriers_offers = Repo.all(CourierOffer)
    render(conn, "index.json", couriers_offers: couriers_offers)
  end

  def create(conn, %{"courier_offer" => courier_offer_params}) do

    user = Guardian.Plug.current_resource(conn)

    departure_place_params = Halftame.Google.place_details(courier_offer_params["departure_place_id"])
    return_place_params = Halftame.Google.place_details(courier_offer_params["destination_place_id"])

    case Multi.new
         |> Multi.run(:courier_offer, fn value -> courier_offer_user_association(courier_offer_params, user) end)
         |> Multi.run(:departure_place, &(departure_place_courier_offer_association(departure_place_params, &1.courier_offer)))
         |> Multi.run(:destination_place, &(destination_place_courier_offer_association(return_place_params, &1.courier_offer)))
         |> Repo.transaction() do
      {:ok, %{courier_offer: courier_offer}} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", courier_offer_path(conn, :show, courier_offer))
        |> render("show.json", courier_offer: courier_offer)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Halftame.ChangesetView, "error.json", changeset: changeset)
    end
  end

  defp courier_offer_user_association(courier_offer_params, %User{} = user) do

    courier_offer =
    user
    |> Ecto.build_assoc(:courier_offers)
    |> CourierOffer.changeset(courier_offer_params)
    |> Repo.insert
  end

  defp departure_place_courier_offer_association(place_params, %CourierOffer{} = courier_offer) do

    departure_place =
    courier_offer
    |> Ecto.build_assoc(:departure_place)
    |> Place.changeset(place_params)
    |> Repo.insert()
  end

  defp destination_place_courier_offer_association(place_params, %CourierOffer{} = courier_offer) do

    destination_place =
    courier_offer
    |> Ecto.build_assoc(:destination_place)
    |> Place.changeset(place_params)
    |> Repo.insert()
  end

  def show(conn, %{"id" => id}) do
    courier_offer = Repo.get!(CourierOffer, id)
    render(conn, "show.json", courier_offer: courier_offer)
  end

  def update(conn, %{"id" => id, "courier_offer" => courier_offer_params}) do
    courier_offer = Repo.get!(CourierOffer, id)
    changeset = CourierOffer.changeset(courier_offer, courier_offer_params)

    case Repo.update(changeset) do
      {:ok, courier_offer} ->
        render(conn, "show.json", courier_offer: courier_offer)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Halftame.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    courier_offer = Repo.get!(CourierOffer, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(courier_offer)

    send_resp(conn, :no_content, "")
  end
end
