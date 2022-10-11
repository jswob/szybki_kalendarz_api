defmodule SzybkiKalendarzApi.Accounts.GoogleUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "google_users" do
    field :avatar_url, :string
    field :email, :string

    timestamps()
  end

  @doc false
  def changeset(google_user, attrs) do
    google_user
    |> cast(attrs, [:email, :avatar_url])
    |> validate_required([:email])
  end
end
