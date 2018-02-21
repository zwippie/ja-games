defmodule KlikkerWeb.SpijkerplankControllerTest do
  use KlikkerWeb.ConnCase

  alias Klikker.Games
  alias Klikker.Games.Spijkerplank

  @create_attrs %{name: "Huisje", segments: [[40,38],[38,48],[48,60],[60,62],[62,40],[60,38]]}
  @update_attrs %{name: "Ander Huisje"}
  @invalid_attrs %{name: "", segments: "123"}

  def fixture(:spijkerplank) do
    {:ok, spijkerplank} = Games.create_spijkerplank(@create_attrs)
    spijkerplank
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all spijkerplanken", %{conn: conn} do
      conn = get conn, spijkerplank_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create spijkerplank" do
    test "renders spijkerplank when data is valid", %{conn: conn} do
      conn = post conn, spijkerplank_path(conn, :create), spijkerplank: @create_attrs
      assert %{"id" => id, "name" => "Huisje", "segments" => [[40,38],[38,48],[48,60],[60,62],[62,40],[60,38]]} = json_response(conn, 201)["data"]

      conn = get conn, spijkerplank_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id, "name" => "Huisje", "segments" => [[40,38],[38,48],[48,60],[60,62],[62,40],[60,38]]}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, spijkerplank_path(conn, :create), spijkerplank: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update spijkerplank" do
    setup [:create_spijkerplank]

    test "renders spijkerplank when data is valid", %{conn: conn, spijkerplank: %Spijkerplank{id: id} = spijkerplank} do
      conn = put conn, spijkerplank_path(conn, :update, spijkerplank), spijkerplank: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, spijkerplank_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id, "name" => "Ander Huisje", "segments" => [[40,38],[38,48],[48,60],[60,62],[62,40],[60,38]]}
    end

    test "renders errors when data is invalid", %{conn: conn, spijkerplank: spijkerplank} do
      conn = put conn, spijkerplank_path(conn, :update, spijkerplank), spijkerplank: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete spijkerplank" do
    setup [:create_spijkerplank]

    test "deletes chosen spijkerplank", %{conn: conn, spijkerplank: spijkerplank} do
      conn = delete conn, spijkerplank_path(conn, :delete, spijkerplank)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, spijkerplank_path(conn, :show, spijkerplank)
      end
    end
  end

  defp create_spijkerplank(_) do
    spijkerplank = fixture(:spijkerplank)
    {:ok, spijkerplank: spijkerplank}
  end
end
