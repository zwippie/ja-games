defmodule KlikkerWeb.SessionControllerTest do
  use KlikkerWeb.ConnCase

  alias Klikker.Auth

  @create_attrs %{username: "some username", password: "some password"}
  @invalid_attrs %{username: "", password: ""}

  def fixture(:user) do
    {:ok, user} = Auth.create_user(@create_attrs)
    user
  end

  describe "new session" do
    test "renders form", %{conn: conn} do
      conn = get conn, session_path(conn, :new)
      assert html_response(conn, 200) =~ "Inloggen"
    end
  end

  describe "create session" do
    setup [:create_user]

    test "redirects to root when data is valid", %{conn: conn} do
      conn = post conn, session_path(conn, :create), user: @create_attrs
      assert redirected_to(conn) == page_path(conn, :index)

      conn = get conn, page_path(conn, :index)
      assert html_response(conn, 200) =~ "Hallo some username!"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, session_path(conn, :create), user: @invalid_attrs
      assert html_response(conn, 200) =~ "Incorrect username or password"
    end
  end

  describe "delete session" do
    setup [:create_user]

    test "deletes chosen session", %{conn: conn} do
      conn = delete conn, session_path(conn, :delete, false)
      assert redirected_to(conn) == page_path(conn, :index)
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
