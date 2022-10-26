defmodule SzybkiKalendarzApiWeb.AuthView do
  @moduledoc false

  use SzybkiKalendarzApiWeb, :view

	def render("logout.json", _attrs) do
		%{
			message: "logged out"
		}
	end
end
