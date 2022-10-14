defmodule SzybkiKalendarzApi.Repo.Migrations.CreateCongregations do
  use Ecto.Migration

  def change do
    create table(:congregations) do
      add :email, :text
      add :name, :text
			add :avatar_url, :text

      timestamps()
    end

		create unique_index(:congregations, [:email])
  end
end
