defmodule SzybkiKalendarzApiWeb.PageController do
  use SzybkiKalendarzApiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
