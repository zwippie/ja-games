defmodule KlikkerWeb.SessionController do
  use KlikkerWeb, :controller

  alias Klikker.Auth
  alias Klikker.Auth.User
  alias Klikker.Auth.Guardian, as: KlikkerGuardian

  def new(conn, _) do
    changeset = Auth.change_user(%User{})
    maybe_user = KlikkerGuardian.Plug.current_resource(conn)

    render(conn, "new.html", changeset: changeset, maybe_user: maybe_user)
  end

  def create(conn, %{"user" => %{"username" => username, "password" => password}}) do
    changeset = Auth.change_user(%User{username: username})

    Auth.authenticate_user(username, password)
    |> login_reply(conn, changeset)
  end

  defp login_reply({:error, error}, conn, changeset) do
    maybe_user = KlikkerGuardian.Plug.current_resource(conn)

    conn
    |> put_flash(:error, error)
    |> render("new.html", changeset: changeset, maybe_user: maybe_user)
  end

  defp login_reply({:ok, user}, conn, _) do
    conn
    |> put_flash(:info, "Hallo #{user.username}!")
    |> KlikkerGuardian.Plug.sign_in(user)
    |> redirect(to: page_path(conn, :index))
  end

  def delete(conn, _) do
    conn
    |> KlikkerGuardian.Plug.sign_out()
    |> redirect(to: page_path(conn, :index))
  end
end
