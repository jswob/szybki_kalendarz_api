defmodule SzybkiKalendarzApi.Repo.Migrations.CreateGoogleUsers do
  use Ecto.Migration

  def change do
    create table(:google_users) do
      add :email, :string
      add :avatar_url, :string

      timestamps()
    end

		create unique_index(:google_users, [:email])
  end
end
