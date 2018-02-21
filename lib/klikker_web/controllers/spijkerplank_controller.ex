defmodule KlikkerWeb.SpijkerplankController do
  use KlikkerWeb, :controller

  alias Klikker.Games
  alias Klikker.Games.Spijkerplank

  action_fallback KlikkerWeb.FallbackController

  def index(conn, _params) do
    spijkerplanken = Games.list_spijkerplanken()
    render(conn, "index.json", spijkerplanken: spijkerplanken)
  end

  def create(conn, %{"spijkerplank" => spijkerplank_params}) do
    with {:ok, %Spijkerplank{} = spijkerplank} <- Games.create_spijkerplank(spijkerplank_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", spijkerplank_path(conn, :show, spijkerplank))
      |> render("show.json", spijkerplank: spijkerplank)
    end
  end

  def show(conn, %{"id" => id}) do
    spijkerplank = Games.get_spijkerplank!(id)
    render(conn, "show.json", spijkerplank: spijkerplank)
  end

  def update(conn, %{"id" => id, "spijkerplank" => spijkerplank_params}) do
    spijkerplank = Games.get_spijkerplank!(id)

    with {:ok, %Spijkerplank{} = spijkerplank} <- Games.update_spijkerplank(spijkerplank, spijkerplank_params) do
      render(conn, "show.json", spijkerplank: spijkerplank)
    end
  end

  def delete(conn, %{"id" => id}) do
    spijkerplank = Games.get_spijkerplank!(id)
    with {:ok, %Spijkerplank{}} <- Games.delete_spijkerplank(spijkerplank) do
      send_resp(conn, :no_content, "")
    end
  end
end
