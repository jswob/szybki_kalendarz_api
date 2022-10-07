defmodule SzybkiKalendarzApiWeb.Router do
  use SzybkiKalendarzApiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
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
  end

  scope "/", SzybkiKalendarzApiWeb do
    get "/", PageController, :index
  end
end
