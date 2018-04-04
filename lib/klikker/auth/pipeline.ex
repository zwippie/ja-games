defmodule Klikker.Auth.Pipeline do
  @moduledoc """
  Pipeline where a user *may be* authenticated.
  """

  use Guardian.Plug.Pipeline, otp_app: :klikker

  # If there is a session token, validate it
  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}

  # If there is an authorization header, validate it
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}

  # In this app a user *may be* authenticated, so don't require this line
  # plug Guardian.Plug.EnsureAuthenticated

  # Load the user if either of the verifications worked
  plug Guardian.Plug.LoadResource, allow_blank: true
end
