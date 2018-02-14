defmodule KlikkerWeb.PageControllerTest do
  use KlikkerWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Jelle"
  end

  test "GET /klikker", %{conn: conn} do
    conn = get conn, "/klikker"
    assert html_response(conn, 200) =~ "Klikker Game"
  end

  test "GET /lunar_lander", %{conn: conn} do
    conn = get conn, "/lunar_lander"
    assert html_response(conn, 200) =~ "Lunar Lander"
  end
end
