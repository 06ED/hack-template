defmodule HackTemplateBackend.Swagger do
  alias PhoenixSwagger.{Path, Path.PathObject}

  def bearer_security(path = %PathObject{}), do: Path.security(path, [%{BearerAuth: []}])
end
