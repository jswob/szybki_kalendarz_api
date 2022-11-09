defmodule SzybkiKalendarzApiWeb.Router do
  use SzybkiKalendarzApiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
		plug CORSPlug, origin: ["http://localhost:3000"]
    plug :put_secure_browser_headers
  end

 	pipeline :sign_in do
		plug :clear_session
	end

	scope "/auth", SzybkiKalendarzApiWeb do
		pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete

		scope "/sign-in" do
			pipe_through :sign_in

			get "/manager", AuthController, :sign_in_manager
			get "/congregation", AuthController, :sign_in_congregation
		end
	end

  pipeline :api do
    plug :accepts, ["json"]
		plug :fetch_session
		plug :authenticate
		plug SzybkiKalendarzApiWeb.Context
		plug CORSPlug, origin: ["http://localhost:3000"]
  end

	scope "/api", SzybkiKalendarzApiWeb do
		pipe_through :api

		get "/session", PageController, :session
	end

	scope "/graphql" do
		pipe_through [:api]

		post "/", Absinthe.Plug, schema: SzybkiKalendarzApiWeb.Schema
	end

	def clear_session(conn, _opts) do
		clear_session(conn)
	end

	def authenticate(conn, _opts) do
		case get_session(conn) do
			%{
				"current_user_id" => _,
				"account_type" => _
			} ->
				conn

			_ ->
				conn
				|> put_status(401)
				|> put_view(SzybkiKalendarzApiWeb.ErrorView)
				|> render("401.json")
		end
	end
end
