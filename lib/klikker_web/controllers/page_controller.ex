defmodule KlikkerWeb.PageController do
  use KlikkerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def robot_puzzel(conn, _params) do
    render conn, "robot_puzzel.html"
  end
end
