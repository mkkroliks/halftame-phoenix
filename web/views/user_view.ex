defmodule Halftame.UserView do
  use Halftame.Web, :view

  def render("index.json", %{users: users}) do
    %{user: render_many(users, Halftame.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{user: render_one(user, Halftame.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      name: user.name,
      token: user.token}
  end
end
