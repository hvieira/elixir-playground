defmodule DummyProductApiWeb.Router do
  use DummyProductApiWeb, :router

  import DummyProductApiWeb.Auth.ClientAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {DummyProductApiWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_user_info
  end

  scope "/api", DummyProductApiWeb do
    pipe_through :api

    resources "/users", UserController, only: [:create]
    post "/login", LoginController, :login
  end

  scope "/api", DummyProductApiWeb do
    pipe_through [:api, :require_authenticated_user]

    resources "/products", ProductController, only: [:create, :update]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DummyProductApiWeb.Telemetry
    end
  end
end
