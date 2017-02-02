defmodule Halftame.UserController do
  require IEx
  use Halftame.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__
  def logged_in_action(conn, params) do
    IEx.pry
    user = Guardian.Plug.current_resource(conn)
    # do your stuff
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> render "error.json", message: "Authentication required"
  end

  import Ecto.Query
  # https://graph.facebook.com/me?access_token=
  # https://graph.facebook.com/me?fields=email&access_token=EAADZAJLAaYN8BAHUxJKkoiZC1KWpTuFjzZCXRJIZCFmPgvFZBByiVzVRzsJ9RZCqVpF6ZBPEL6mH2gXrBog3P2yPjigEoFgqJ9F9C97Yi5Aay0kKZCZCZCsk9jO9eHQZC5bYKz9eji7NgZAXLNEUo5NrKrHFBFrQ4wfk7zzkuaQ4vys79XPAsqL4pNf8ATwhr4gxYRX10oMaixAW8tXEFpEPOlMWh1ODINyds80ZD

  def index(conn, _params) do
    users = Halftame.Repo.all(Halftame.User)
    render(conn, "index.json", users: users)
  end
end
