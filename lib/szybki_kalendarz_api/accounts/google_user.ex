defmodule SzybkiKalendarzApi.Accounts.GoogleUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "google_users" do
    field :avatar_url, :string
    field :email, :string
		field :type, Ecto.Enum, values: [manager: "manager", congregation: "congregation"]
  end

  @doc false
  def changeset(google_user, attrs) do
    google_user
    |> cast(attrs, [:email, :type, :avatar_url])
    |> validate_required([:email, :type])
  end
end
