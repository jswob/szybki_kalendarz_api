defmodule SzybkiKalendarzApi.Accounts.Congregation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "congregations" do
    field :email, :string
    field :name, :string
		field :avatar_url, :string

    timestamps()
  end

  @doc false
  def changeset(congregation, attrs) do
    congregation
    |> cast(attrs, [:email, :name, :avatar_url])
    |> validate_required([:email])
  end
end
