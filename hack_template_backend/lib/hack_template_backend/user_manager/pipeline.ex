defmodule HackTemplateBackend.UserManager.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :hack_template_backend,
    error_handler: HackTemplateBackend.UserManager.ErrorHandler,
    module: HackTemplateBackend.UserManager.Guardian

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}

  plug Guardian.Plug.LoadResource, allow_blank: true
end
