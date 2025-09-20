defmodule HackTemplateBackendWeb.SessionController do
  use HackTemplateBackendWeb, :controller
  use PhoenixSwagger

  import HackTemplateBackend.Swagger
  alias HackTemplateBackend.{UserManager, UserManager.Guardian}

  def swagger_definitions do
    %{
      LoginUserRq:
        swagger_schema do
          title("LoginUserRq")
          description("POST body for logining in")

          properties do
            email(:string, "Email", required: true, format: :email)
            password(:string, "Password", required: true)
          end
        end,
      LoginUserRs:
        swagger_schema do
          title("LoginUserRs")
          description("Response schema for logined user")

          properties do
            access_token(:string, "Access token", required: true)
            refresh_token(:string, "Refresh token", required: true)
          end
        end,
      CreateUserRq:
        swagger_schema do
          title("CreateUserRq")
          description("POST body for creating a user")

          properties do
            email(:string, "Email", required: true, format: :email)
            password(:string, "Password", required: true)
          end
        end,
      CreateUserRs:
        swagger_schema do
          title("CreateUserRs")
          description("Response schema for created user")

          properties do
            id(:integer, "User id", required: true)
            email(:string, "Email", required: true, format: :email)
            inserted_at(:string, "Create timestamp", required: true, format: :datetime)
            updated_at(:string, "Update timestamp", required: true, format: :datetime)
          end
        end
    }
  end

  swagger_path :logout do
    get("/api/users/logout")
    tag("users")
    bearer_security()

    response(204, "User logouted")
  end

  swagger_path :register do
    post("/api/users/register")
    tag("users")

    produces("application/json")
    consumes("application/json")

    parameter(:user, :body, Schema.ref(:CreateUserRq), "The user details",
      example: %{email: "example@mail.com", password: "pass"}
    )

    response(201, "User created", Schema.ref(:CreateUserRs),
      example: %{
        id: 1,
        email: "example@mail.com",
        inserted_at: "2017-02-08T12:34:55Z",
        updated_at: "2017-02-12T13:45:23Z"
      }
    )
  end

  swagger_path :login do
    post("/api/users/login")
    tag("users")

    produces("application/json")
    consumes("application/json")

    parameter(:user, :body, Schema.ref(:LoginUserRq), "The user details",
      example: %{email: "example@mail.com", password: "pass"}
    )

    response(200, "User logined", Schema.ref(:LoginUserRs),
      example: %{
        access_token: "string",
        refresh_token: "another string"
      }
    )
  end

  swagger_path :refresh do
    post("/api/users/refresh")
    tag("users")

    produces("application/json")
    consumes("application/json")

    parameter(
      :user,
      :body,
      Schema.new do
        properties do
          refresh_token(:string, "User's refresh token", required: true)
        end
      end,
      "User refresh token data",
      example: %{
        refresh_token: "another string"
      }
    )

    response(
      200,
      "User token refreshed",
      Schema.new do
        properties do
          access_token(:string, "User's access token", required: true)
        end
      end,
      example: %{
        access_token: "string"
      }
    )
  end

  def register(conn, %{"email" => _, "password" => _} = register_data) do
    case UserManager.create_user(register_data) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(%{
          id: user.id,
          email: user.email,
          inserted_at: user.inserted_at,
          updated_at: user.updated_at
        })

      {:error, _changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{
          error: "Failed to create user"
        })
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case UserManager.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, access_token, _access_claims} =
          UserManager.Guardian.encode_and_sign(user, %{}, token_type: "access")

        {:ok, refresh_token, _refresh_claims} =
          UserManager.Guardian.encode_and_sign(user, %{}, token_type: "refresh", ttl: {2, :weeks})

        conn
        |> put_status(:ok)
        |> json(%{
          access_token: access_token,
          refresh_token: refresh_token
        })
    end
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_status(:no_content)
    |> json(%{})
  end

  def refresh(conn, %{"refresh_token" => refresh_token}) do
    case UserManager.Guardian.exchange(refresh_token, "refresh", "access") do
      {:ok, {_old_token, _old_claims}, {new_token, _new_claims}} ->
        conn
        |> put_status(:ok)
        |> json(%{
          access_token: new_token
        })

      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid refresh token"})
    end
  end
end
