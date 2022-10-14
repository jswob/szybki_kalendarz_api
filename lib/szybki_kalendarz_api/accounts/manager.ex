defmodule SzybkiKalendarzApi.Accounts.Manager do
  use Ecto.Schema
  import Ecto.Changeset

  schema "managers" do
    field :avatar_url, :string
    field :email, :string

    timestamps()
  end

  @doc false
  def changeset(manager, attrs) do
    manager
    |> cast(attrs, [:email, :avatar_url])
    |> validate_required([:email, :avatar_url])
  end
end
