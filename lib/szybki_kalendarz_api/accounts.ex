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
  def get_google_user_by_email(email) do
    case Repo.get_by(GoogleUser, email: email) do
			%GoogleUser{} = google_user -> {:ok, google_user}

			nil -> {:error, :not_found}
		end
  end

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

	def find_or_create_google_user_from_auth(%Auth{info: %Info{email: email, image: avatar_url}}) do
		case get_google_user_by_email(email) do
			{:ok, user} -> {:ok, user}

			{:error, :not_found} ->
				%{email: email, avatar_url: avatar_url}
				|> create_google_user()
		end
	end
end
