defmodule SzybkiKalendarzApi.Accounts.GoogleUser do
  use Ecto.Schema
  import Ecto.Changeset

  alias SzybkiKalendarzApi.Tokens.GoogleToken

  schema "google_users" do
    field :avatar_url, :string
    field :email, :string
    field :type, Ecto.Enum, values: [manager: "manager", congregation: "congregation"]

    belongs_to :token, GoogleToken
  end

  @doc false
  def changeset(google_user, attrs) do
    google_user
    |> cast(attrs, [:email, :type, :avatar_url])
    # |> cast_token(attrs)
    |> validate_required([:email, :type])
  end

  # defp cast_token(user, %{token: %GoogleToken{} = token}),
  #   do: put_assoc(user, :token, token)

  # defp cast_token(_, _),
  #   do: throw("Missing required parameter \"access_token\" on google_user changeset")
end
