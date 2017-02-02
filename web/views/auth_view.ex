defmodule Halftame.AuthView do
  require IEx
  use Halftame.Web, :view

  # def render("login.json", %{users: users}) do
  #   %{user: render_many(users, Halftame.UserView, "user.json")}
  # end
  #
  # def render("show.json", %{user: user}) do
  #   %{user: render_one(user, Halftame.UserView, "user.json")}
  # end

  def render("auth.json", %{user: user, jwt: jwt, exp: exp}) do
    %{access_token: jwt,
      token_type: "Bearer",
      expires_in: exp,
      refresh_token: "NOT DEFINED YET"}
  end

  def render("error.json", %{message: message}) do
    %{message: message}
  end

end
