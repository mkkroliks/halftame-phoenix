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
    IEx.pry
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
    IEx.pry
    Enum.each([
        get(conn, user_path(conn, :show, "123"))
    ], fn conn ->
      IEx.pry
      assert json_response(conn, 401)
      assert conn.halted
    end)
  end

  # test "lists all entries on index", %{conn: conn} do
  #   conn = get conn, user_path(conn, :index)
  #   assert json_response(conn, 200)["data"] == []
  # end
  #
  # test "shows chosen resource", %{conn: conn} do
  #   user = Repo.insert! %User{}
  #   conn = get conn, user_path(conn, :show, user)
  #   assert json_response(conn, 200)["data"] == %{"id" => user.id,
  #     "name" => user.name,
  #     "token" => user.token}
  # end
  #
  # test "renders page not found when id is nonexistent", %{conn: conn} do
  #   assert_error_sent 404, fn ->
  #     get conn, user_path(conn, :show, -1)
  #   end
  # end
  #
  # test "creates and renders resource when data is valid", %{conn: conn} do
  #   conn = post conn, user_path(conn, :create), user: @valid_attrs
  #   assert json_response(conn, 201)["data"]["id"]
  #   assert Repo.get_by(User, @valid_attrs)
  # end
  #
  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, user_path(conn, :create), user: @invalid_attrs
  #   assert json_response(conn, 422)["errors"] != %{}
  # end
  #
  # test "updates and renders chosen resource when data is valid", %{conn: conn} do
  #   user = Repo.insert! %User{}
  #   conn = put conn, user_path(conn, :update, user), user: @valid_attrs
  #   assert json_response(conn, 200)["data"]["id"]
  #   assert Repo.get_by(User, @valid_attrs)
  # end
  #
  # test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
  #   user = Repo.insert! %User{}
  #   conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
  #   assert json_response(conn, 422)["errors"] != %{}
  # end
  #
  # test "deletes chosen resource", %{conn: conn} do
  #   user = Repo.insert! %User{}
  #   conn = delete conn, user_path(conn, :delete, user)
  #   assert response(conn, 204)
  #   refute Repo.get(User, user.id)
  # end
end
