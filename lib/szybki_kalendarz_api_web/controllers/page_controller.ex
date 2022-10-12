defmodule SzybkiKalendarzApiWeb.PageController do
  use SzybkiKalendarzApiWeb, :controller

	def session(conn, _params) do
		conn
		|> render("session.json", user: conn.assigns.session.current_user)
	end
end
