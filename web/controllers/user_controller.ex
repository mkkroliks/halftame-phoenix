defmodule Halftame.UserController do
  require IEx
  use Halftame.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__
  import Ecto.Query
  alias Halftame.Repo

  def unauthenticated(conn, error) do
    IEx.pry
    conn
    |> put_status(401)
    |> render("error.json", message: "Authentication required")
  end

  def index(conn, _params) do
    users = Repo.all(Halftame.User)
    render(conn, "index.json", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(Halftame.User, id)
    render(conn, "show.json", user: user)
  end

  def me(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    render(conn, "show.json", user: user)
  end
end
