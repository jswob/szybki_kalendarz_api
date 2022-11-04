defmodule SzybkiKalendarzApi.Accounts.Manager do
  use Ecto.Schema
  import Ecto.Changeset
  alias SzybkiKalendarzApi.Accounts.GoogleUser

  schema "managers" do
    belongs_to :owner, GoogleUser

    timestamps()
  end

  @doc false
  def changeset(manager, attrs) do
    manager
    |> cast(attrs, [])
    |> cast_owner(attrs)
  end

  def cast_owner(manager, %{owner: %GoogleUser{} = owner}) do
    case owner do
      nil ->
        throw "manager: owner can't be nil."

      _ ->
        put_assoc(manager, :owner, owner)
    end
  end
end
