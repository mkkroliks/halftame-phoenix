defmodule Halftame.CourierOfferController do
  use Halftame.Web, :controller

  alias Halftame.CourierOffer

  def index(conn, _params) do
    couriers_offers = Repo.all(CourierOffer)
    render(conn, "index.json", couriers_offers: couriers_offers)
  end

  def create(conn, %{"courier_offer" => courier_offer_params}) do
    changeset = CourierOffer.changeset(%CourierOffer{}, courier_offer_params)

    case Repo.insert(changeset) do
      {:ok, courier_offer} ->
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
