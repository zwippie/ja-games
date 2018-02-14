defmodule KlikkerWeb.Router do
  use KlikkerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", KlikkerWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/klikker", PageController, :klikker
    get "/lunar_landing", PageController, :lunar_landing
  end

  # Other scopes may use custom stacks.
  scope "/api", KlikkerWeb do
    pipe_through :api

    get "/lunar_landing", PageController, :new_lunar_landing
  end
end
