defmodule SzybkiKalendarzApi.Accounts.Congregation do
  use Ecto.Schema
  import Ecto.Changeset
	alias SzybkiKalendarzApi.Accounts.GoogleUser

  schema "congregations" do
    field :name, :string
		belongs_to :owner, GoogleUser

    timestamps()
  end

  @doc false
  def changeset(congregation, attrs) do
    congregation
    |> cast(attrs, [:name])
		|> cast_owner(attrs)
  end

	def cast_owner(congregation, %{owner: %GoogleUser{} = owner}) do
		case owner do
			nil ->
				throw "congregation: owner can't be nil."

			id ->
				put_assoc(congregation, :owner, owner)
		end
	end
end
