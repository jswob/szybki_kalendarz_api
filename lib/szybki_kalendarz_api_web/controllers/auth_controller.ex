defmodule SzybkiKalendarzApiWeb.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """

  use SzybkiKalendarzApiWeb, :controller

  plug Ueberauth

  alias Ueberauth.Strategy.Helpers
	alias SzybkiKalendarzApi.Accounts

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> clear_session()
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Accounts.find_or_create_google_user_from_auth(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_session, %{
					access_token: auth.credentials.token,
					current_user: user,
				})
        |> configure_session(renew: true)
				|> put_resp_content_type("application/json")
        |> redirect(external: "http://localhost:3000/landing")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
				|> configure_session(renew: true)
        |> redirect(to: "/")
    end
  end
end
