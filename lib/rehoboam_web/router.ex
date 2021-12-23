defmodule RehoboamWeb.Router do
  use RehoboamWeb, :router

  get "/_k8s/*path", Potionx.Plug.Health, health_module: Rehoboam.Health

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Potionx.Plug.ServiceContext

    # plug Potionx.Plug.Auth,
    #   session_optional: false,
    #   session_service: Rehoboam.Sessions.SessionService
  end

  pipeline :graphql do
    plug :accepts, ["json"]
    plug Potionx.Plug.ServiceContext

    # plug Potionx.Plug.Auth,
    #   session_optional: true,
    #   session_service: Rehoboam.Sessions.SessionService,
    #   user_optional: true

    if Mix.env() in [:prod, :test] do
      plug Potionx.Plug.MaybeDisableIntrospection, roles: [:admin]
    end

    plug Potionx.Plug.UrqlUpload
    plug Potionx.Plug.Absinthe
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :require_auth do
    plug Potionx.Plug.RequireAuth
  end
  pipeline :require_unauth do
    plug Potionx.Plug.RequireUnauth
  end

  pipeline :auth_callback do
    plug :accepts, ["json"]
    plug Potionx.Plug.ServiceContext

    plug Potionx.Plug.Auth,
      session_optional: false,
      session_service: Rehoboam.Sessions.SessionService,
      user_optional: true
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

      live_dashboard "/dashboard", metrics: RehoboamWeb.Telemetry
    end
  end

  scope "/graphql/v1" do
    pipe_through :graphql

    forward "/", Absinthe.Plug,
      analyze_complexity: true,
      before_send: {Potionx.Auth.Resolvers, :before_send},
      max_complexity: 3000,
      schema: RehoboamGraphQl.Schema
  end


  scope "/api/v1", as: :api_v1 do
    pipe_through :auth_callback

    get "/auth/:provider/callback",
        Potionx.Auth.Resolvers,
        scheme: (Mix.env() === :prod && "https") || "http",
        session_service: Rehoboam.Sessions.SessionService

    post "/auth/:provider/callback",
         Potionx.Auth.Resolvers,
         scheme: (Mix.env() === :prod && "https") || "http",
         session_service: Rehoboam.Sessions.SessionService
  end

  scope "/login", RehoboamWeb do
    pipe_through [:browser, :require_unauth]
    get "/", AppController, :index
  end

  scope "/", RehoboamWeb do
    pipe_through [:browser]
    get "/*path", AppController, :index
  end
  # Other scopes may use custom stacks.
  # scope "/api", RehoboamWeb do
  #   pipe_through :api
  # end


  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
