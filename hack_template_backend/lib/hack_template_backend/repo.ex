defmodule HackTemplateBackend.Repo do
  use Ecto.Repo,
    otp_app: :hack_template_backend,
    adapter: Ecto.Adapters.Postgres
end
