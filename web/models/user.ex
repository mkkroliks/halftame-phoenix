defmodule Halftame.User do
  require IEx
  use Halftame.Web, :model

  schema "users" do
    field :name, :string
    field :token, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :token])
    |> validate_required([:name, :token])
  end

  def login_by_facebook_token(conn, token, opts) do
    repo = Keyword.fetch!(opts, :repo)

    {:json, map} = facebook_user_params(token)
    longlife_token = Map.get(map, "access_token")

    {:json, params} = Facebook.me("email, first_name, photo", longlife_token)
    params = Map.put(params, :fb_access_token, longlife_token)

    case params do
      %{email: email, first_name: first_name, photo: photo, fb_access_token: longlife_token} ->
          if user = repo.get_by(Halftame.User, email: email) do
            {:ok, user}
          else
            changeset = Halftame.User.changeset(%Halftame.User{}, params)

            case Repo.insert(changeset) do
            {:ok, user} ->
              {:ok, user}
            {:error, changest} ->
              {:error, "cannot create user"}
            end
          end
      true ->
        {:error, ""}
    end
  end

  def facebook_user_params(token) do
    IEx.pry
    # {:json, params} = Facebook.me("first_name, email, photo", token)
    fb_app_id = Application.fetch_env!(:halftame, :fb_app_id)
    fb_app_secret = Application.fetch_env!(:halftame, :fb_app_secret)
    token = Facebook.Graph.get("oauth/access_token", [grant_type: "fb_exchange_token",
                                              client_id: fb_app_id,
                                              client_secret: fb_app_secret,
                                              fb_exchange_token: token])
    IEx.pry
    token
  end

end
