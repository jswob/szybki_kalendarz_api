defmodule SzybkiKalendarzApiWeb.Context do
  @behaviour Plug

  import Plug.Conn
  alias SzybkiKalendarzApi.Accounts
  alias SzybkiKalendarzApi.Accounts.{GoogleUser,Manager,Congregation}
	alias SzybkiKalendarzApi.Repo

	# alias SzybkiKalendarzApi.Ac

  def init(opts), do: opts

  def call(conn, _) do
		context_with_user = build_context(conn)
		Absinthe.Plug.put_options(conn, context: context_with_user)
  end

  defp build_context(conn) do
    with session <- get_session(conn),
			%{} = context <- authenticate(session) do
			context
		else
			_ -> %{}
		end
  end

  defp authenticate(session) do
    case session do
      %{
        "current_user_id" => id,
        "account_type" => type
      } ->
				%{}
				|> assign_google_user(id)
				|> assign_token()
				|> assign_subaccount()

      _ ->
        {:error, :unautenticated}
    end
  end

	defp assign_google_user(context, id) do
		case Accounts.get_google_user_by_id(id) do
			nil -> context
			%GoogleUser{} = google_user ->
				Map.put(context, :google_user, google_user)
		end
	end

	defp assign_token(%{google_user: google_user} = context) do
		case Repo.one(Ecto.assoc(google_user, :token)) do
			nil -> context
			token -> Map.put(context, :token, token)
		end
	end

	defp assign_token(context), do: context

	defp assign_subaccount(%{google_user: google_user} = context) do
		case Repo.one(Ecto.assoc(google_user, google_user.type)) do
			nil -> context
			subaccount -> Map.put(context, google_user.type, subaccount)
		end
	end

	defp assign_subaccount(context), do: context
end
