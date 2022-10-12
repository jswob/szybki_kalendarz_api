defmodule SzybkiKalendarzApiWeb.Router do
  use SzybkiKalendarzApiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
		plug CORSPlug
    plug :put_secure_browser_headers
  end

	scope "/auth", SzybkiKalendarzApiWeb do
		pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
	end

  pipeline :api do
    plug :accepts, ["json"]
		plug :fetch_session
		plug :authenticate
		plug CORSPlug, origin: ["http://localhost:3000"]
  end

	scope "/api", SzybkiKalendarzApiWeb do
		pipe_through :api

		get "/session", PageController, :session
	end

	def authenticate(conn, _opts) do
		case get_session(conn) do
			%{"current_session" => current_session} ->
				conn
				|> assign(:session, current_session)

			%{} ->
				conn
				|> put_status(401)
				|> put_view(SzybkiKalendarzApiWeb.ErrorView)
				|> render("401.json")
		end
	end
end
