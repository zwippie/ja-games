defmodule KlikkerWeb.PageController do
  use KlikkerWeb, :controller

  alias Klikker.Games
  alias Klikker.Games.Idea

  alias Klikker.Auth
  alias Klikker.Auth.User
  alias Klikker.Auth.Guardian

  def index(conn, _params) do
    changeset = Games.change_idea(%Idea{})
    render(conn, "index.html", changeset: changeset)
  end

  def klikker(conn, _params) do
    render(conn, "klikker.html")
  end

  def lunar_lander(conn, _params) do
    render(conn, "lunar_lander.html")
  end

  def spijkerplank(conn, _params) do
    render(conn, "spijkerplank.html")
  end

  def santorini(conn, _params) do
    render(conn, "santorini.html")
  end

  def machikoro(conn, _params) do
    render(conn, "machikoro.html")
  end

  def dobbelen(conn, _params) do
    render(conn, "dobbelen.html")
  end

  def ganzenbord(conn, _params) do
    render(conn, "ganzenbord.html")
  end

  def programmeren(conn, _params) do
    render(conn, "programmeren.html")
  end

  def new_lunar_lander(conn, _params) do
    json(conn, %{grid: Klikker.RobotPuzzel.Generator.generate()})
  end

  # POST /login
  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    changeset = Auth.change_user(%User{username: username})

    Auth.authenticate_user(username, password)
    |> login_reply(conn, changeset)
  end

  # GET /login
  def login(conn, _) do
    changeset = Auth.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)
    render(conn, "login.html", changeset: changeset, action: page_path(conn, :login), maybe_user: maybe_user)
  end

  defp login_reply({:error, error}, conn, changeset) do
    maybe_user = Guardian.Plug.current_resource(conn)

    conn
    |> put_flash(:error, error)
    |> render("login.html", changeset: changeset, action: page_path(conn, :login), maybe_user: maybe_user)
  end

  defp login_reply({:ok, user}, conn, _) do
    IO.inspect "User has logged in:"
    IO.inspect user
    conn
    |> put_flash(:info, "Hallo #{user.username}!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/")
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/")
  end
end
