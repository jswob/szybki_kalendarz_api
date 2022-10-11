defmodule SzybkiKalendarzApi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias SzybkiKalendarzApi.Repo

  alias SzybkiKalendarzApi.Accounts.GoogleUser
	alias Ueberauth.Auth
	alias Ueberauth.Auth.Info

  @doc """
  Creates a google_user.

  ## Examples

      iex> create_google_user(%{field: value})
      {:ok, %GoogleUser{}}

      iex> create_google_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_google_user(attrs \\ %{}) do
    %GoogleUser{}
    |> GoogleUser.changeset(attrs)
    |> Repo.insert()
  end

	@doc """
  Returns an `%GoogleUser{}`. It takes %Ueberauth.Auth{} struct and
	returns matching %GoogleUser{} struct if it exsists and creates a new one
	otherwise.

  ## Examples

      iex> find_or_create_google_user_from_auth(google_user)
      {:ok, %GoogleUser{}}

  """
	def find_or_create_google_user_from_auth(%Auth{info: %Info{email: email, image: avatar_url}}) do
		case Repo.get_by(GoogleUser, email: email) do
			%GoogleUser{} = user -> {:ok, user}

			nil ->
				%{email: email, avatar_url: avatar_url}
				|> create_google_user()
		end
	end
end
