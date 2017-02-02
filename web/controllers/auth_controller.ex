defmodule Halftame.AuthController do
  require IEx
  use Halftame.Web, :controller

  # %{"auth" => %{"token"}}
  # %{"token" => token}
  def create(conn, %{"token" => token}) do
    case Halftame.User.login_by_facebook_token(conn, token, repo: Repo) do
       {:ok, user} ->
         new_conn = Guardian.Plug.api_sign_in(conn, user)
         jwt = Guardian.Plug.current_token(new_conn)
         claims = Guardian.Plug.claims(new_conn)
         {_, map} = claims
         exp = Map.get(map, "exp")

         new_conn
         |> put_resp_header("authorization", "Bearer #{jwt}")
         |> put_resp_header("x-expires", "#{exp}")
         |> render "auth.json", user: user, jwt: jwt, exp: exp
       {:error, _connection} ->
         conn
         |> put_status(401)
         |> render "error.json", message: "Could not login"
    end
  end

end