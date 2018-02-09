defmodule KlikkerWeb.PageController do
  use KlikkerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
