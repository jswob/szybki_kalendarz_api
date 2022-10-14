defmodule SzybkiKalendarzApiWeb.PageController do
  use SzybkiKalendarzApiWeb, :controller

	def session(conn, _params) do
		%{
			"current_session" => %{current_user: user},
			"account_type" => account_type
		} = get_session(conn)

		conn
		|> render("session.json", %{user: user, account_type: account_type})
	end
end
