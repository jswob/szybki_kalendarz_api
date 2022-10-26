defmodule SzybkiKalendarzApiWeb.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """

  use SzybkiKalendarzApiWeb, :controller

  plug Ueberauth

  alias Ueberauth.Strategy.Helpers
	alias SzybkiKalendarzApi.Accounts
	alias SzybkiKalendarzApiWeb.AuthView

	def request(conn, %{"provider" => "logout"}) do
		conn
    |> put_flash(:info, "You have been logged out!")
    |> clear_session()
    |> render(AuthView, "logout.json")
	end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
		%{"account_type" => account_type} = get_session(conn)

    case Accounts.find_or_create_account_from_auth(account_type, auth) do
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

      {:error, :wrong_account_type} ->
        conn
        |> put_flash(:error, :wrong_account_type)
				|> configure_session(renew: true)
				|> redirect(external: "http://localhost:3000/landing/error/wrong-account-type")

			{:error, reason} ->
				conn
				|> put_flash(:error, reason)
				|> configure_session(renew: true)
				|> render(SzybkiKalendarzApiWeb.ErrorView, "error.json", %{message: reason})
    end
  end

	def sign_in_manager(conn, _params) do
		conn
		|> put_session(:account_type, "manager")
		|> redirect(to: "/auth/google")
	end

	def sign_in_congregation(conn, _params) do
		conn
		|> put_session(:account_type, "congregation")
		|> redirect(to: "/auth/google")
	end
end
