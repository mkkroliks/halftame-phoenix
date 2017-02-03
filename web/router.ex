defmodule Halftame.Router do
  use Halftame.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/api", Halftame do
    pipe_through :api
    resources "/users", UserController
    resources "/auth", AuthController, only: [:create, :delete]
  end
end
