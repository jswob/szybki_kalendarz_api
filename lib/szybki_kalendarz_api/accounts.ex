defmodule SzybkiKalendarzApi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias SzybkiKalendarzApi.Repo

  alias SzybkiKalendarzApi.Accounts.Manager
	alias Ueberauth.Auth
	alias Ueberauth.Auth.Info

	def get_manager_by_email(email) do
    case Repo.get_by(Manager, email: email) do
			%Manager{} = manager -> {:ok, manager}

			nil -> {:error, :not_found}
		end
  end

	def create_manager(attrs \\ %{}) do
    %Manager{}
    |> Manager.changeset(attrs)
    |> Repo.insert()
  end

	# def get_congregation_by_email(email) do
  #   case Repo.get_by(GoogleUser, email: email) do
	# 		%GoogleUser{} = google_user -> {:ok, google_user}

	# 		nil -> {:error, :not_found}
	# 	end
  # end



	# def create_congregation(attrs \\ %{}) do
  #   %GoogleUser{}
  #   |> GoogleUser.changeset(attrs)
  #   |> Repo.insert()
  # end

	def find_or_create_account_from_auth(%Auth{info: %Info{email: email, image: avatar_url}}, "manager") do
		case get_manager_by_email(email) do
			{:ok, user} -> {:ok, user}

			{:error, :not_found} ->
				%{email: email, avatar_url: avatar_url}
				|> create_manager()
		end
	end

	# def find_or_create_account_from_auth(%Auth{info: %Info{email: email, image: avatar_url}}, "congregation") do
	# 	case get_congregation_by_email(email) do
	# 		{:ok, user} -> {:ok, user}

	# 		{:error, :not_found} ->
	# 			%{email: email, avatar_url: avatar_url}
	# 			|> create_congregation()
	# 	end
	# end
end
