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
    user = repo.get_by(Halftame.User, token: token)

    cond do
      user ->
        {:ok, user}
      true ->
        {:error, conn}
    end
  end

end
