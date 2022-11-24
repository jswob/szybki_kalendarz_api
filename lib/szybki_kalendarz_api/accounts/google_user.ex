defmodule SzybkiKalendarzApi.Accounts.GoogleUser do
  use Ecto.Schema
  import Ecto.Changeset

  alias SzybkiKalendarzApi.Tokens.GoogleToken
	alias SzybkiKalendarzApi.Accounts.{Manager,Congregation}

	@primary_key {:id, :binary_id, autogenerate: true}

  schema "google_users" do
    field :avatar_url, :string
    field :email, :string
    field :type, Ecto.Enum, values: [manager: "manager", congregation: "congregation"]

    belongs_to :token, GoogleToken, type: :binary_id

		has_one :manager, Manager, foreign_key: :owner_id
		has_one :congregation, Congregation, foreign_key: :owner_id
  end

  @doc false
  def changeset(google_user, attrs) do
    google_user
    |> cast(attrs, [:email, :type, :avatar_url])
    |> validate_required([:email, :type])
  end
end
