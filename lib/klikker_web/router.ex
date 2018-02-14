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
    get "/robot_puzzel", PageController, :robot_puzzel
  end

  # Other scopes may use custom stacks.
  scope "/api", KlikkerWeb do
    pipe_through :api

    get "/robot_puzzel", PageController, :new_robot_puzzel
  end
end
