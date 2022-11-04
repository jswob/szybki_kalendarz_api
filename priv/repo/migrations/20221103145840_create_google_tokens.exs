defmodule SzybkiKalendarzApi.Repo.Migrations.CreateGoogleTokens do
  use Ecto.Migration

  def change do
    create table(:google_tokens, primary_key: false) do
			add :id, :uuid, primary_key: true
      add :token, :string
      add :refresh_token, :string
      add :expires_at, :date

      timestamps()
    end

    alter table(:google_users) do
      add :token_id, references(:google_tokens, type: :uuid)
    end

    create unique_index(:google_users, [:token_id])
  end
end
