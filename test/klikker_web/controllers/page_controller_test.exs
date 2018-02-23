defmodule KlikkerWeb.PageControllerTest do
  use KlikkerWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Jelle en Arnold"
  end

  test "GET /klikker", %{conn: conn} do
    conn = get(conn, "/klikker")
    assert html_response(conn, 200) =~ "Klikker Game"
  end

  test "GET /lunar_lander", %{conn: conn} do
    conn = get(conn, "/lunar_lander")
    assert html_response(conn, 200) =~ "Lunar Lander"
  end

  test "GET /spijkerplank", %{conn: conn} do
    conn = get(conn, "/spijkerplank")
    assert html_response(conn, 200) =~ "Projekt Spijkerplank"
  end

  test "GET /santorini", %{conn: conn} do
    conn = get(conn, "/santorini")
    assert html_response(conn, 200) =~ "Santorini"
  end

  test "GET /api/lunar_lander", %{conn: conn} do
    conn = get(conn, "/api/lunar_lander")
    assert json_response(conn, 200)
  end
end
