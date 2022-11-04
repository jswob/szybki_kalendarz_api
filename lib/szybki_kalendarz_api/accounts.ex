defmodule SzybkiKalendarzApi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias SzybkiKalendarzApi.Repo

  alias SzybkiKalendarzApi.Tokens
  alias SzybkiKalendarzApi.Tokens.GoogleToken
  alias SzybkiKalendarzApi.Accounts.Manager
  alias SzybkiKalendarzApi.Accounts.Congregation
  alias SzybkiKalendarzApi.Accounts.GoogleUser
  alias Ueberauth.Auth
  alias Ueberauth.Auth.Info

  def get_google_user_by_id(id) do
    from(gu in GoogleUser, where: gu.id == ^id)
    |> Repo.one()
  end

  def get_google_user_by_email(email) do
    case Repo.all(
           from gu in GoogleUser,
             where: gu.email == ^email
         ) do
      [user | _] -> {:ok, user}
      [] -> {:error, :not_found}
    end
  end

  def create_account_from_google_user({:ok, %GoogleUser{type: type} = owner_data}) do
    {:ok, %{owner: google_user}} =
      case type do
        :manager -> create_manager_from_google_user(owner_data)
        :congregation -> create_congregation_from_google_user(owner_data)
      end

    google_user
  end

  def create_manager_from_google_user(%GoogleUser{} = owner) do
    %Manager{}
    |> Manager.changeset(%{owner: owner})
    |> dbg()
    |> Repo.insert()
  end

  def create_congregation_from_google_user(%GoogleUser{} = owner) do
    %Congregation{}
    |> Congregation.changeset(%{owner: owner})
    |> Repo.insert()
  end

  def create_google_user(%GoogleToken{} = token, attrs \\ %{}) do
    %GoogleUser{}
    |> GoogleUser.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:token, token)
    |> dbg()
    |> Repo.insert()
  end

  def create_google_user(attr1, attr2) do
    dbg(attr1)
    dbg(attr2)
  end

  def find_or_create_account_from_auth(type, %Auth{info: user_data, credentials: token_data}) do
    case get_google_user_by_email(user_data.email) do
      {:ok, user} ->
        check_account_type(user, type)

      {:error, :not_found} ->
        Repo.transaction(fn ->
          Tokens.create_google_token!(token_data)
          |> create_google_user(%{
            email: user_data.email,
            avatar_url: user_data.image,
            type: type
          })
          |> dbg()
          |> create_account_from_google_user()
        end)
    end
  end

  defp assign_token_to_user_data(user_data, %Ueberauth.Auth.Credentials{} = creadentials) do
    case Tokens.create_google_token(creadentials) do
      {:ok, token} ->
        Map.put(user_data, :token, token)

      _ ->
        throw("Unable to create token from credentials")
    end
  end

  defp check_account_type(%GoogleUser{type: account_type} = account, type) do
    cond do
      String.to_atom(type) == account_type ->
        {:ok, account}

      true ->
        {:error, :wrong_account_type}
    end
  end
end
