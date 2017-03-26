defmodule Halftame.UserView do
  use Halftame.Web, :view

  def render("index.json", %{users: users}) do
    %{user: render_many(users, Halftame.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    render_one(user, Halftame.UserView, "user.json")
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      first_name: user.first_name,
      photo: user.photo,
      email: user.email}
  end

  def render("error.json", %{message: message}) do
    %{message: message}
  end

  def display(user: user) do
    %{id: user.id,
      first_name: user.first_name,
      photo: user.photo,
      email: user.email}
  end
end
