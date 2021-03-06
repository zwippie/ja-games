defmodule KlikkerWeb.IdeaControllerTest do
  use KlikkerWeb.ConnCase

  alias Klikker.Games
  alias Klikker.Auth
  alias Klikker.Auth.Guardian, as: KlikkerGuardian

  @create_attrs %{body: "some body", name: "some name"}
  @update_attrs %{body: "some updated body", name: "some updated name"}
  @invalid_attrs %{body: nil, name: nil}

  def fixture(:idea) do
    {:ok, idea} = Games.create_idea(@create_attrs)
    idea
  end

  def fixture(:user) do
    {:ok, user} = Auth.create_user(%{username: "username", password: "password"})
    user
  end

  describe "index" do
    setup [:login_as_user]

    test "lists all ideas", %{conn: conn} do
      conn = get conn, idea_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Ideas"
    end
  end

  describe "new idea" do
    setup [:login_as_user]

    test "renders form", %{conn: conn} do
      conn = get conn, idea_path(conn, :new)
      assert html_response(conn, 200) =~ "New Idea"
    end
  end

  describe "create idea" do
    test "redirects to root when data is valid", %{conn: conn} do
      conn = post conn, idea_path(conn, :create), idea: @create_attrs
      assert redirected_to(conn) == page_path(conn, :index)

      conn = get conn, page_path(conn, :index)
      assert html_response(conn, 200) =~ "Dankjewel voor je idee!"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, idea_path(conn, :create), idea: @invalid_attrs
      assert html_response(conn, 200) =~ "Dat klopt niet helemaal."
    end
  end

  describe "edit idea" do
    setup [:login_as_user, :create_idea]

    test "renders form for editing chosen idea", %{conn: conn, idea: idea} do
      conn = get conn, idea_path(conn, :edit, idea)
      assert html_response(conn, 200) =~ "Edit Idea"
    end
  end

  describe "update idea" do
    setup [:login_as_user, :create_idea]

    test "redirects when data is valid", %{conn: conn, idea: idea, user: user} do
      conn = put conn, idea_path(conn, :update, idea), idea: @update_attrs
      assert redirected_to(conn) == idea_path(conn, :show, idea)

      conn = get conn, idea_path(conn, :show, idea)
      assert html_response(conn, 200) =~ "some updated body"
    end

    test "renders errors when data is invalid", %{conn: conn, idea: idea} do
      conn = put conn, idea_path(conn, :update, idea), idea: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Idea"
    end
  end

  describe "delete idea" do
    setup [:login_as_user, :create_idea]

    test "deletes chosen idea", %{conn: conn, idea: idea} do
      conn = delete conn, idea_path(conn, :delete, idea)
      assert redirected_to(conn) == idea_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, idea_path(conn, :show, idea)
      end
    end
  end

  defp create_idea(_) do
    idea = fixture(:idea)
    {:ok, idea: idea}
  end

  defp login_as_user(%{conn: conn}) do
    user = fixture(:user)
    # {:ok, token, _} = Guardian.encode_and_sign(user, %{}, token_type: :access)
    {:ok, token, _} = KlikkerGuardian.encode_and_sign(user, %{}, token_type: :access)
    # conn = KlikkerGuardian.Plug.sign_in(conn, user)
    # conn = guardian_login(conn, user)
    conn = put_req_header(conn, "authorization", "bearer: " <> token)
    {:ok, conn: conn}
  end
end
