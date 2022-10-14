defmodule SzybkiKalendarzApiWeb.PageView do
  use SzybkiKalendarzApiWeb, :view

	def render("session.json", %{user: user, account_type: account_type}) do
		%{
			current_user: %{
				id: user.id,
				email: user.email,
				avatar_url: user.avatar_url,
				account_type: account_type,
			}
		}
	end
end
