defmodule HackTemplateBackendWeb.Router do
  use HackTemplateBackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    # plug PhoenixSwagger.Plug.Validate
  end

  pipeline :auth do
    plug HackTemplateBackend.UserManager.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  get "/", HackTemplateBackendWeb.RedirectController, :to_docs

  scope "/docs" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :hack_template_backend,
      swagger_file: "swagger.json"
  end

  scope "/api", HackTemplateBackendWeb do
    pipe_through :api

    scope "/users" do
      post "/register", SessionController, :register
      post "/refresh", SessionController, :refresh

      pipe_through :auth
      post "/login", SessionController, :login
      pipe_through :ensure_auth
      get "/logout", SessionController, :logout
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:hack_template_backend, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: HackTemplateBackendWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Hack Template app"
      },
      securityDefinitions: %{
        BearerAuth: %{
          description: "Type \"Bearer\" followed by a space and JWT token.",
          type: "apiKey",
          name: "Authorization",
          in: "header"
        }
      }
    }
  end
end
