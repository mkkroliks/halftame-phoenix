defmodule Halftame.Router do
  use Halftame.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Halftame do
    pipe_through :api
  end
end
