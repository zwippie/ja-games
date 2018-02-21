defmodule KlikkerWeb.Router do
  use KlikkerWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", KlikkerWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/klikker", PageController, :klikker)
    get("/lunar_lander", PageController, :lunar_lander)
    get("/spijkerplank", PageController, :spijkerplank)
  end

  # Other scopes may use custom stacks.
  scope "/api", KlikkerWeb do
    pipe_through(:api)

    get("/lunar_lander", PageController, :new_lunar_lander)
  end
end
