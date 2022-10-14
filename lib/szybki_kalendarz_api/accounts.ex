defmodule SzybkiKalendarzApi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias SzybkiKalendarzApi.Repo

  alias SzybkiKalendarzApi.Accounts.Manager
  alias SzybkiKalendarzApi.Accounts.Congregation
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

	def get_congregation_by_email(email) do
    case Repo.get_by(Congregation, email: email) do
			%Congregation{} = congregation -> {:ok, congregation}

			nil -> {:error, :not_found}
		end
  end

	def create_congregation(attrs \\ %{}) do
    %Congregation{}
    |> Congregation.changeset(attrs)
    |> Repo.insert()
  end

	def find_or_create_account_from_auth("manager", %Auth{info: %Info{email: email, image: avatar_url}}) do
		case get_manager_by_email(email) do
			{:ok, user} -> {:ok, user}

			{:error, :not_found} ->
				%{email: email, avatar_url: avatar_url}
				|> create_manager()
		end
	end

	def find_or_create_account_from_auth("congregation", %Auth{info: %Info{email: email}}) do
		case get_congregation_by_email(email) do
			{:ok, congregation} -> {:ok, congregation}

			{:error, :not_found} ->
				%{email: email, name: "Nowy Zbór: #{email}"}
				|> create_congregation()
		end
	end
end
