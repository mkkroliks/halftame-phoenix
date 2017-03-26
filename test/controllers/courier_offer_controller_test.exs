defmodule Halftame.CourierOfferControllerTest do
  require IEx
  use Halftame.ConnCase

  alias Halftame.CourierOffer
  @valid_attrs %{departure_date: %{day: 17, month: 4, year: 2010}, return_date: %{day: 17, month: 4, year: 2010}, departure_place_id: "ChIJ3Qv0eaL4BEcRr92HxIebhI4", destination_place_id: "ChIJ3Qv0eaL4BEcRr92HxIebhI4"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    # {:ok, conn: put_req_header(conn, "accept", "application/json")}
    user = insert_user()
    {:ok, jwt, full_claims} = Guardian.encode_and_sign(user)

    new_conn = conn
     |> put_req_header("authorization", "Bearer #{jwt}")

    {:ok, %{jwt: jwt, claims: full_claims, conn: new_conn}}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, courier_offer_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  # test "shows chosen resource", %{conn: conn} do
  #   courier_offer = Repo.insert! %CourierOffer{}
  #   conn = get conn, courier_offer_path(conn, :show, courier_offer)
  #   assert json_response(conn, 200)["data"] == %{"id" => courier_offer.id,
  #     "user_id" => courier_offer.user_id,
  #     "departure_date" => courier_offer.departure_date,
  #     "return_date" => courier_offer.return_date}
  # end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, courier_offer_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, courier_offer_path(conn, :create), courier_offer: @valid_attrs
    assert json_response(conn, 201)["id"]
    assert json_response(conn, 201)["user"]
    assert json_response(conn, 201)["destination_place"]
    assert json_response(conn, 201)["departure_place"]
    assert json_response(conn, 201)["departure_date"]
    assert json_response(conn, 201)["return_date"]
    id = json_response(conn, 201)["id"]
    assert Repo.get_by(CourierOffer, id: id)
  end

  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, courier_offer_path(conn, :create), courier_offer: @invalid_attrs
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  # test "updates and renders chosen resource when data is valid", %{conn: conn} do
  #   courier_offer = Repo.insert! %CourierOffer{}
  #   conn = put conn, courier_offer_path(conn, :update, courier_offer), courier_offer: @valid_attrs
  #   assert json_response(conn, 200)["data"]["id"]
  #   assert Repo.get_by(CourierOffer, @valid_attrs)
  # end

  # test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
  #   courier_offer = Repo.insert! %CourierOffer{}
  #   conn = put conn, courier_offer_path(conn, :update, courier_offer), courier_offer: @invalid_attrs
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  test "deletes chosen resource", %{conn: conn} do
    courier_offer = Repo.insert! %CourierOffer{}
    conn = delete conn, courier_offer_path(conn, :delete, courier_offer)
    assert response(conn, 204)
    refute Repo.get(CourierOffer, courier_offer.id)
  end

  test "requires authentication on all actions", %{conn: conn} do
    conn = build_conn()
    Enum.each([
        get(conn, courier_offer_path(conn, :show, "123"))
    ], fn conn ->
      assert json_response(conn, 401)
      assert conn.halted
    end)
  end

end
