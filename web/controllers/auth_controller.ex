defmodule Halftame.AuthController do
  require IEx
  use Halftame.Web, :controller

  def unauthenticated(conn, error) do
    conn
    |> put_status(401)
    |> render("error.json", message: "Authentication required")
  end

  def create(conn, %{"token" => token}) do
    case Halftame.User.login_by_facebook_token(conn, token, repo: Repo) do
       {:ok, user} ->
         case Guardian.encode_and_sign(user) do
          {:ok, jwt, full_claims} ->

           exp = Map.get(full_claims, "exp")

           conn
           |> put_resp_header("authorization", "Bearer #{jwt}")
           |> put_resp_header("x-expires", "#{exp}")
           |> render "auth.json", user: user, jwt: jwt, exp: exp
          {:error, :token_storage_failure} -> # this comes from GuardianDb
                    IEx.pry
          {:error, reason} -> # handle failure
                    IEx.pry
        end
       {:error, _connection} ->
         conn
         |> put_status(401)
         |> render "error.json", message: "Could not login"
    end
  end

  def delete(conn, _) do

    jwt = Guardian.Plug.current_token(conn)
    claims = Guardian.Plug.claims(conn)

    {_, map} = claims
    IEx.pry
    case Guardian.revoke!(jwt, map) do
      :ok ->
        conn
        |> render("logout.json", message: "Successfuly logged out")
      {:error, :could_not_revoke_token} ->
        conn
        |> render("logout.json", message: "Server error")
      {:error, reason} ->
        conn
        |> render("logout.json", message: "Server error")
    end
  end

end
