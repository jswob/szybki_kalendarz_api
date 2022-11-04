defmodule SzybkiKalendarzApi.Repo.Migrations.CreateGoogleTokens do
  use Ecto.Migration

  def change do
    create table(:google_tokens) do
      add :token, :string
      add :refresh_token, :string
      add :expires_at, :date

      timestamps()
    end

    alter table(:google_users) do
      add :token_id, references(:google_tokens), null: false
    end

    create unique_index(:google_users, [:token_id])
  end
end
