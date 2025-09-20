defmodule HackTemplateBackendWeb.RedirectController do
  use HackTemplateBackendWeb, :controller

  def to_docs(conn, _) do
    redirect(conn, to: "/docs")
  end
end
