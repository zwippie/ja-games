defmodule KlikkerWeb.Router do
  use KlikkerWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  # 'Maybe authenticated' pipeline
  pipeline :auth do
    plug Klikker.Auth.Pipeline
  end

  # Add :auth and :ensure_auth to make a 'definitely authenticated' pipeline
  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated, error_handler: Klikker.Auth.ErrorHandler
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", KlikkerWeb do
    pipe_through [:browser, :auth]

    get("/", PageController, :index)
    get("/klikker", PageController, :klikker)
    get("/lunar_lander", PageController, :lunar_lander)
    get("/spijkerplank", PageController, :spijkerplank)
    get("/santorini", PageController, :santorini)
    get("/machikoro", PageController, :machikoro)
    get("/dobbelen", PageController, :dobbelen)
    get("/ganzenbord", PageController, :ganzenbord)
    get("/programmeren", PageController, :programmeren)

    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/users", UserController, only: [:new, :create]
    resources "/ideas", IdeaController, only: [:create]
  end

  scope "/", KlikkerWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    resources "/ideas", IdeaController, only: [:index, :delete]
    get("/profile", PageController, :profile)
  end

  # Other scopes may use custom stacks.
  scope "/api", KlikkerWeb do
    pipe_through(:api)

    get("/lunar_lander", PageController, :new_lunar_lander)
    resources "/spijkerplanken", SpijkerplankController, except: [:new, :edit]
  end
end
