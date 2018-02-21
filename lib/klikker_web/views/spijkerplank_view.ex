defmodule KlikkerWeb.SpijkerplankView do
  use KlikkerWeb, :view
  alias KlikkerWeb.SpijkerplankView

  def render("index.json", %{spijkerplanken: spijkerplanken}) do
    %{data: render_many(spijkerplanken, SpijkerplankView, "spijkerplank.json")}
  end

  def render("show.json", %{spijkerplank: spijkerplank}) do
    %{data: render_one(spijkerplank, SpijkerplankView, "spijkerplank.json")}
  end

  def render("spijkerplank.json", %{spijkerplank: spijkerplank}) do
    %{
      id: spijkerplank.id,
      name: spijkerplank.name,
      segments: spijkerplank.segments
    }
  end
end
