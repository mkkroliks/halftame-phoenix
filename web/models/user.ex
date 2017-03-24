defmodule Halftame.User do
  require IEx
  use Halftame.Web, :model

  alias Halftame.User

  schema "users" do
    field :first_name, :string
    field :fb_token, :string
    field :photo, :string
    field :email, :string
    has_many :courier_offers, Halftame.CourierOffer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:first_name, :fb_token, :photo, :email])
    |> validate_required([:first_name, :fb_token, :photo, :email])
  end

  def login_by_facebook_token(conn, token, opts) do
    repo = Keyword.fetch!(opts, :repo)

    {:json, map} = facebook_user_params(token)
    longlife_token = Map.get(map, "access_token")

    {:json, string_key_map} = Facebook.me("email, first_name, picture", longlife_token)

    atom_map = for {key, val} <- string_key_map, into: %{}, do: {String.to_atom(key), val}

    %{"data" => picture_dict} = atom_map[:picture]
    photo_url = Map.get(picture_dict, "url")

    params = atom_map
    |> Map.delete(:picture)
    |> Map.put(:photo, photo_url)
    |> Map.put(:fb_token, longlife_token)

    case params do
      %{email: email, first_name: first_name, photo: photo, fb_token: longlife_token} ->
          if user = repo.get_by(User, email: email) do
            changeset = User.changeset(user, params)

            case repo.update(changeset) do
              {:ok, user} ->
                {:ok, user}
              {:error, changest} ->
                {:ok, user}
            end
          else
            changeset = User.changeset(%User{}, params)
            case repo.insert(changeset) do
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
    # {:json, params} = Facebook.me("first_name, email, photo", token)
    fb_app_id = Application.fetch_env!(:halftame, :fb_app_id)
    fb_app_secret = Application.fetch_env!(:halftame, :fb_app_secret)
    token = Facebook.Graph.get("oauth/access_token", [grant_type: "fb_exchange_token",
                                              client_id: fb_app_id,
                                              client_secret: fb_app_secret,
                                              fb_exchange_token: token])
    token
  end

end
