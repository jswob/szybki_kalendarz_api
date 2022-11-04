defmodule SzybkiKalendarzApi.Tokens do
  alias SzybkiKalendarzApi.Repo
  alias SzybkiKalendarzApi.Tokens.GoogleToken

  def create_google_token(%Ueberauth.Auth.Credentials{} = cred) do
    %GoogleToken{}
    |> GoogleToken.changeset(%{
      token: cred.token,
      refresh_token: cred.refresh_token,
      expires_at: DateTime.from_unix!(cred.expires_at)
    })
    |> Repo.insert()
  end

  def create_google_token!(creadentials) do
    {:ok, token} = create_google_token(creadentials)
    token
  end
end
