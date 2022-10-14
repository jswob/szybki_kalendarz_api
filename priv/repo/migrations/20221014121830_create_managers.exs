defmodule SzybkiKalendarzApi.Repo.Migrations.CreateManagers do
  use Ecto.Migration

  def change do
    create table(:managers) do
      add :email, :string
      add :avatar_url, :string

      timestamps()
    end

		create unique_index(:managers, [:email])
  end
end
