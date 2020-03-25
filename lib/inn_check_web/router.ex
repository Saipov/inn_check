defmodule InnCheckWeb.Router do
  use InnCheckWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug InnCheckWeb.Plug.PublicIp
  end

  pipeline :auth do
    plug InnCheck.Accounts.Pipeline
    plug InnCheckWeb.Plug.AdminLayout
    plug InnCheckWeb.Plug.LoadUser
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", InnCheckWeb do
    pipe_through :browser

    resources "/", ClientController, only: [:index] do
      resources "/inns", InnController, only: [:create]
    end
  end

  scope "/admin", InnCheckWeb.Admin, as: :admin do
    pipe_through [:browser, :auth]

    get "/login", SessionController, :new
    post "/login", SessionController, :login
    get "/logout", SessionController, :logout
  end

  scope "/admin", InnCheckWeb.Admin, as: :admin do
    pipe_through [:browser, :auth, :ensure_auth]
    get "/", DashboardController, :index
    resources "/users", UserController
    resources "/clients", ClientController
    resources "/inns", InnController
  end

  # Other scopes may use custom stacks.
  # scope "/api", InnCheckWeb do
  #   pipe_through :api
  # end
end
