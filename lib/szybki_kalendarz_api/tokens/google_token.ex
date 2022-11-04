defmodule SzybkiKalendarzApi.Tokens.GoogleToken do
  use Ecto.Schema
  import Ecto.Changeset

  schema "google_tokens" do
    field :expires_at, :date
    field :refresh_token, :string
    field :token, :string

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = google_token, attrs) do
    google_token
    |> cast(attrs, [:token, :refresh_token, :expires_at])
    |> validate_required([:token, :expires_at])
    |> unique_constraint([:token])
  end
end
