defmodule Halftame.SendOfferController do
  use Halftame.Web, :controller

  alias Halftame.SendOffer

  def index(conn, _params) do
    send_offers = Repo.all(SendOffer)
    render(conn, "index.json", send_offers: send_offers)
  end

  def create(conn, %{"send_offer" => send_offer_params}) do
    changeset = SendOffer.changeset(%SendOffer{}, send_offer_params)

    case Repo.insert(changeset) do
      {:ok, send_offer} ->
        conn
        |> put_status(:created)
        # |> put_resp_header("location", send_offer_path(conn, :show, send_offer))
        |> render("show.json", send_offer: send_offer)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Halftame.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    send_offer = Repo.get!(SendOffer, id)
    render(conn, "show.json", send_offer: send_offer)
  end

  def update(conn, %{"id" => id, "send_offer" => send_offer_params}) do
    send_offer = Repo.get!(SendOffer, id)
    changeset = SendOffer.changeset(send_offer, send_offer_params)

    case Repo.update(changeset) do
      {:ok, send_offer} ->
        render(conn, "show.json", send_offer: send_offer)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Halftame.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    send_offer = Repo.get!(SendOffer, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(send_offer)

    send_resp(conn, :no_content, "")
  end
end
