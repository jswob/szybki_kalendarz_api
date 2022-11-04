defmodule SzybkiKalendarzApiWeb.PageController do
  use SzybkiKalendarzApiWeb, :controller

  alias SzybkiKalendarzApi.Accounts
  alias SzybkiKalendarzApi.Accounts.GoogleUser

  def session(conn, _params) do
    %{
      "current_user_id" => user_id,
      "account_type" => account_type
    } = get_session(conn)

    case Accounts.get_google_user_by_id(user_id) do
      %GoogleUser{} = user ->
        render(conn, "session.json", %{user: user, account_type: account_type})

      nil ->
        throw "User can't be found"
    end
  end
end
