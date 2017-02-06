defmodule Halftame.ExampleControllerTest do
  use Halftame.ConnCase

  alias Halftame.Example
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, example_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    example = Repo.insert! %Example{}
    conn = get conn, example_path(conn, :show, example)
    assert json_response(conn, 200)["data"] == %{"id" => example.id,
      "name" => example.name}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, example_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, example_path(conn, :create), example: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Example, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, example_path(conn, :create), example: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    example = Repo.insert! %Example{}
    conn = put conn, example_path(conn, :update, example), example: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Example, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    example = Repo.insert! %Example{}
    conn = put conn, example_path(conn, :update, example), example: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    example = Repo.insert! %Example{}
    conn = delete conn, example_path(conn, :delete, example)
    assert response(conn, 204)
    refute Repo.get(Example, example.id)
  end
end
