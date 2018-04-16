defmodule KlikkerWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      import KlikkerWeb.Router.Helpers

      # The default endpoint for testing
      @endpoint KlikkerWeb.Endpoint

      # We need a way to get into the connection to login a user
      # We need to use the bypass_through to fire the plugs in the router
      # and get the session fetched.
      def guardian_login(%Klikker.Auth.User{} = user), do: guardian_login(conn(), user, :token, [])
      def guardian_login(%Klikker.Auth.User{} = user, token), do: guardian_login(conn(), user, token, [])
      def guardian_login(%Klikker.Auth.User{} = user, token, opts), do: guardian_login(conn(), user, token, opts)

      def guardian_login(%Plug.Conn{} = conn, user), do: guardian_login(conn, user, :token, [])
      def guardian_login(%Plug.Conn{} = conn, user, token), do: guardian_login(conn, user, token, [])
      def guardian_login(%Plug.Conn{} = conn, user, token, opts) do
        conn
          |> bypass_through(KlikkerWeb.Router, [:browser])
          |> get("/")
          # |> Map.update!(:state, fn (_) -> :set end)
          |> Klikker.Auth.Guardian.Plug.sign_in(user) #, token, opts)
          |> send_resp(200, "Flush the session yo")
          |> recycle()
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Klikker.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Klikker.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
