defmodule Halftame.UserControllerTest do
  require IEx
  use Halftame.ConnCase

  alias Halftame.User
  @valid_attrs %{name: "some content", token: "some content"}
  @invalid_attrs %{}

  # setup %{conn: conn} do
  #   {:ok, conn: put_req_header(conn, "accept", "application/json")}
  # end

  setup do
    user = insert_user()
    {:ok, jwt, full_claims} = Guardian.encode_and_sign(user)
    {:ok, %{user: user, jwt: jwt, claims: full_claims}}
  end

  test "GET /api/users/:id", %{user: user, jwt: jwt} do
    conn = build_conn()
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/users/#{user.id}")
    # IEx.pry
    assert json_response(conn, 200) == %{"id" => user.id,
                                         "name" => user.name,
                                         "token" => user.token}
  end

  test "DELETE api/auth/:id", %{jwt: jwt} do
    conn = build_conn()
     |> put_req_header("authorization", "Bearer #{jwt}")
     |> delete("/api/auth/1")

     assert Guardian.decode_and_verify(jwt) == {:error, :token_not_found}
  end

  test "requires user authentication on all actions", %{conn: conn} do
    # IEx.pry
    Enum.each([
        get(conn, user_path(conn, :show, "123"))
    ], fn conn ->
      # IEx.pry
      assert json_response(conn, 401)
      assert conn.halted
    end)
  end

  test "test facebook login params" do
    # token = Application.fetch_env!(:halftame, :facebook_api_token)

    {:json, %{"data" => list}} = Facebook.Graph.get("238751596568799/accounts/test-users",
                                                    [access_token: "238751596568799|ztueE2_tJ9-B1wtIKdta-H14Ph8"])
    access_token = Map.get(List.first(list), "access_token")
    assert User.facebook_user_params(access_token) == %{"email" => "email",
                                                 "first_name" => "first_name",
                                                 "photo" => "photo"}

  end



end
