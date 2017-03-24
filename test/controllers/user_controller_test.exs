defmodule Halftame.UserControllerTest do
  require IEx
  use Halftame.ConnCase

  alias Halftame.User
  @valid_attrs %{name: "some content", token: "some content"}
  @invalid_attrs %{}

  setup do
    user = insert_user()
    {:ok, jwt, full_claims} = Guardian.encode_and_sign(user)
    {:ok, %{user: user, jwt: jwt, claims: full_claims}}
  end

  test "GET /api/users/:id", %{user: user, jwt: jwt} do
    conn = build_conn()
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/users/#{user.id}")

    assert json_response(conn, 200) == %{"id" => user.id,
                                         "email" => user.email,
                                         "first_name" => user.first_name,
                                         "photo" => user.photo}
  end

  test "DELETE api/auth/:id", %{jwt: jwt} do
    conn = build_conn()
     |> put_req_header("authorization", "Bearer #{jwt}")
     |> delete("/api/auth/1")

     assert Guardian.decode_and_verify(jwt) == {:error, :token_not_found}
  end

  test "GET api/users/me", %{jwt: jwt} do
    conn = build_conn()
    |> put_req_header("authorization", "Bearer #{jwt}")
    |> get("/api/users/me")

    assert json_response(conn, 200)
  end

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each([
        get(conn, user_path(conn, :show, "123"))
    ], fn conn ->
      assert json_response(conn, 401)
      assert conn.halted
    end)
  end

  test "test facebook login params" do
    # token = Application.fetch_env!(:halftame, :facebook_api_token)
    fb_app_id = Application.fetch_env!(:halftame, :fb_app_id)
    fb_app_access_token = Application.fetch_env!(:halftame, :fb_app_access_token)
    {:json, %{"data" => list}} = Facebook.Graph.get("#{fb_app_id}/accounts/test-users",
                                                    [access_token: fb_app_access_token])

    access_token = Map.get(List.first(list), "access_token")
    {:json, result} = User.facebook_user_params(access_token)
    assert result["access_token"]
  end



end
