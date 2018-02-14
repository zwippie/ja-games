defmodule KlikkerWeb.PageController do
  use KlikkerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def klikker(conn, _params) do
    render conn, "klikker.html"
  end

  def lunar_lander(conn, _params) do
    render conn, "lunar_lander.html"
  end

  def new_lunar_landing(conn, _params) do
    json conn, %{grid: Klikker.RobotPuzzel.Generator.generate}
  end
end
