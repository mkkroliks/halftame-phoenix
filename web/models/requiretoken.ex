defmodule Halftame.RequireToken do
  @behaviour Plug
  @auth_scheme "Bearer"

  use Plug.Builder
  import Phoenix.Controller, only: [render: 3]

  alias Halftame.{Repo, Token, ErrorView, Crypto.Pbkdf2}

  plug :require_auth_header
  plug :require_bearer_auth
  plug :assign_creds
  plug :assign_token
  plug :check_if_token_expired

  defp require_auth_header(conn, _) do
    if get_req_header(conn, "authorization") == [] do
      conn |> respond_with_error("invalid_token.json")
    else
      conn
    end
  end

  defp require_bearer_auth(conn, _) do
    if bearer_auth?(conn) do
      conn
    else
      conn |> respond_with_error("invalid_token.json")
    end
  end

  defp assign_creds(conn, _) do
    case String.split(bearer_auth_creds(conn), ".") do
      [id, token] -> conn |> assign(:creds, %{id: id, token: token})
      _           -> conn |> respond_with_error("invalid_token.json")
    end
  end

  defp assign_token(conn, _) do
    token = Repo.get(Token, conn.assigns.creds.id)
    access_secret = conn.assigns.creds.token

    if token && Pbkdf2.check(access_secret, token.access_secret_hash) do
      conn |> assign(:token, token)
    else
      conn |> respond_with_error("invalid_token.json")
    end
  end

  defp check_if_token_expired(conn, _) do
    if Token.expired?(conn.assigns.token) do
      conn |> respond_with_error("expired_token.json")
    else
      conn
    end
  end

  defp bearer_auth?(conn) do
    conn
    |> get_authorization_header
    |> String.starts_with?(@auth_scheme <> " ")
  end

  defp bearer_auth_creds(conn) do
    conn
    |> get_authorization_header
    |> String.slice(String.length(@auth_scheme) + 1..-1)
  end

  defp get_authorization_header(conn) do
    conn
    |> get_req_header("authorization")
    |> List.first
  end

  defp respond_with_error(conn, error) do
    conn
    |> put_resp_header("www-authenticate", "Basic realm=\"api.stackd.com\"")
    |> put_status(:unauthorized)
    |> render(ErrorView, error)
    |> halt
  end
end
