defmodule SzybkiKalendarzApi.Accounts.Manager do
  use Ecto.Schema
  import Ecto.Changeset
  alias SzybkiKalendarzApi.Accounts.GoogleUser

	@primary_key {:id, :binary_id, autogenerate: true}

  schema "managers" do
    belongs_to :owner, GoogleUser, type: :binary_id

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
