defmodule SzybkiKalendarzApiWeb.PageView do
  use SzybkiKalendarzApiWeb, :view

	def render("session.json", %{user: user}) do
		%{
			current_user: %{
				id: user.id,
				email: user.email,
				avatar_url: user.avatar_url,
			}
		}
	end
end
