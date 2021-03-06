defmodule Halftame.UserController do
  use Halftame.Web, :controller
  alias Halftame.Repo
  import Ecto.Query
  require IEx

  plug Guardian.Plug.EnsureAuthenticated, handler: Halftame.AuthController

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
