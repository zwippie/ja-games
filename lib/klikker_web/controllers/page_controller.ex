defmodule KlikkerWeb.PageController do
  use KlikkerWeb, :controller

  alias Klikker.Games
  alias Klikker.Games.Idea

  alias Klikker.Auth.Guardian, as: KlikkerGuardian

  def index(conn, _params) do
    maybe_user = KlikkerGuardian.Plug.current_resource(conn)
    changeset = Games.change_idea(%Idea{})
    render(conn, "index.html", changeset: changeset, maybe_user: maybe_user)
  end

  def klikker(conn, _params) do
    render(conn, "klikker.html")
  end

  def lunar_lander(conn, _params) do
    render(conn, "lunar_lander.html")
  end

  def spijkerplank(conn, _params) do
    render(conn, "spijkerplank.html")
  end

  def santorini(conn, _params) do
    render(conn, "santorini.html")
  end

  def machikoro(conn, _params) do
    render(conn, "machikoro.html")
  end

  def dobbelen(conn, _params) do
    render(conn, "dobbelen.html")
  end

  def ganzenbord(conn, _params) do
    render(conn, "ganzenbord.html")
  end

  def programmeren(conn, _params) do
    render(conn, "programmeren.html")
  end

  def new_lunar_lander(conn, _params) do
    json(conn, %{grid: Klikker.RobotPuzzel.Generator.generate()})
  end

  def profile(conn, _params) do
    user = KlikkerGuardian.Plug.current_resource(conn)
    render(conn, "profile.html", user: user)
  end
end
