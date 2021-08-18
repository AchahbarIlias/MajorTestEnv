defmodule JmunitedWeb.Router do
  use JmunitedWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug JmunitedWeb.Plugs.Locale
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :allowed_for_users do
    plug JmunitedWeb.Plugs.AuthorizationPlug, ["Admin", "User"]
  end

  pipeline :allowed_for_admins do
    plug JmunitedWeb.Plugs.AuthorizationPlug, ["Admin"]
  end

  # for non users
  scope "/", JmunitedWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    get "/signup", SessionController, :showSignup
    post "/signup", SessionController, :signup
    get "/login", SessionController, :new
    post "/login", SessionController, :login
    get "/logout", SessionController, :logout

    scope "/products" do
      get "/", ProductController, :index
      get "/:id", ProductController, :show
      get "/filter/by", ProductController, :filter
    end
  end

  #api
  scope "/api", JmunitedWeb do

    get "/products", ProductController, :indexjson
    get "/products/:id", ProductController, :showjson
    get "/users", UserController, :users
    get "/users/:id", UserController, :user
    get "/users/history/:id", CartController, :cart
  end

  #for api admons
  scope "/api", JmunitedWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_admins]
    post "/", ApiController, :generate
  end

  if Mix.env == :dev do
    # If using Phoenix
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  #for users
  scope "/", JmunitedWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_users]

    get "/", PageController, :index
    get "/confirm/:id", SessionController, :confirm
    scope "/profile" do
      get "/", ProfileController, :profile
      get "/edit", ProfileController, :edit
      put "/edit", ProfileController, :editprofile
    end
    scope "/carts" do 
      get "/", CartController, :index
      post "/add/:productid", CartController, :create
      put "/add/:productid", CartController, :update
      get "/order", OrderController, :new
      post "/order", OrderController, :order
      get "/history", OrderController, :history
      get "/history/:orderid", OrderController, :show
      get "/history/retour/:orderid", OrderController, :retour
    end

    scope "/retours" do
      get "/", OrderController, :retourlist
      get "/cancel/:orderid", OrderController, :cancel
    end

  end

  #for admins
  scope "/users", JmunitedWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_admins]

    resources "/", UserController
  end
  

  #products for admins
  scope "/products", JmunitedWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_admins]

    resources "/admin", ProductController
    post "/admin/csv", FileController, :csv 
  end


  pipeline :auth do
    plug JmunitedWeb.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  # Other scopes may use custom stacks.
  # scope "/api", JmunitedWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  # if Mix.env() in [:dev, :test] do
  #   import Phoenix.LiveDashboard.Router

  #   scope "/" do
  #     pipe_through :browser
  #     live_dashboard "/dashboard", metrics: JmunitedWeb.Telemetry
  #   end
  # end
end
