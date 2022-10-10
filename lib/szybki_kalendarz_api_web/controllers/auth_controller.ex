defmodule SzybkiKalendarzApiWeb.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """

  use SzybkiKalendarzApiWeb, :controller

  plug Ueberauth
	plug :super_inspect when action in [:request]

  alias Ueberauth.Strategy.Helpers
  alias SzybkiKalendarzApi.UserFromAuth

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
    case UserFromAuth.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_user, user)
        |> configure_session(renew: true)
				|> put_resp_content_type("application/json")
        |> redirect(external: "http://localhost:3000/landing")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

	def super_inspect(conn, _opts) do
		dbg(conn)
	end
end
