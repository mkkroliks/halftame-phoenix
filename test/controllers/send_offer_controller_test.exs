defmodule Halftame.SendOfferControllerTest do
  use Halftame.ConnCase

  alias Halftame.SendOffer
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, send_offer_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    send_offer = Repo.insert! %SendOffer{}
    conn = get conn, send_offer_path(conn, :show, send_offer)
    assert json_response(conn, 200)["data"] == %{"id" => send_offer.id,
      "user_id" => send_offer.user_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, send_offer_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, send_offer_path(conn, :create), send_offer: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(SendOffer, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, send_offer_path(conn, :create), send_offer: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    send_offer = Repo.insert! %SendOffer{}
    conn = put conn, send_offer_path(conn, :update, send_offer), send_offer: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(SendOffer, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    send_offer = Repo.insert! %SendOffer{}
    conn = put conn, send_offer_path(conn, :update, send_offer), send_offer: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    send_offer = Repo.insert! %SendOffer{}
    conn = delete conn, send_offer_path(conn, :delete, send_offer)
    assert response(conn, 204)
    refute Repo.get(SendOffer, send_offer.id)
  end
end
