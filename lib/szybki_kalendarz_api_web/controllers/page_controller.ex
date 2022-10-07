defmodule SzybkiKalendarzApiWeb.PageController do
  use SzybkiKalendarzApiWeb, :controller

  def index(conn, _params) do
		redirect(conn, to: SzybkiKalendarzApiWeb.Router.Helpers.auth_path(conn, :request, :google))
  end
end
