defmodule Halftame.Router do
  use Halftame.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/api", Halftame do
    pipe_through :api

    get "/users/me", UserController, :me
    post "/google/cities", GoogleController, :cities

    resources "/users", UserController
    resources "/auth", AuthController, only: [:create, :delete]
    resources "/couriers_offers", CourierOfferController, except: [:new, :edit]
  end
end
