defmodule SzybkiKalendarzApi.Repo.Migrations.CreateGoogleUsers do
  use Ecto.Migration

  def change do
    create table(:google_users, primary_key: false) do
			add :id, :uuid, primary_key: true
      add :email, :text
      add :avatar_url, :text
			add :type, :string
    end

		create unique_index(:google_users, [:email])
		create constraint(:google_users, :user_type, check: "type = 'manager' or type = 'congregation'")

		create table(:managers, primary_key: false) do
			add :id, :uuid, primary_key: true
			add :owner_id, references(:google_users, type: :uuid)

			timestamps()
		end

		create table(:congregations, primary_key: false) do
			add :id, :uuid, primary_key: true
			add :name, :text
			add :owner_id, references(:google_users, type: :uuid)

			timestamps()
		end

		create unique_index(:managers, [:owner_id])
		create unique_index(:congregations, [:owner_id])
		create unique_index(:congregations, [:name])
		execute(&execute_up/0, &execute_down/0)
  end

	defp execute_up do
		repo().query!("
			CREATE FUNCTION check_google_user_type(user_id UUID, expected_type VARCHAR)
			RETURNS VOID LANGUAGE plpgsql
			AS $$
				DECLARE
					google_user_type VARCHAR;
				BEGIN
					SELECT type INTO google_user_type FROM (
						SELECT * FROM google_users WHERE id = user_id
					) google_user;

					IF google_user_type != expected_type THEN
						RAISE EXCEPTION 'google_user type incorrect: %, expected: %', google_user_type, expected_type;
					END IF;
				END
			$$;
		")

		repo().query!("
			CREATE FUNCTION check_if_google_user_is_manager() RETURNS TRIGGER LANGUAGE plpgsql
			AS $$
				DECLARE
					google_user_type VARCHAR;
				BEGIN
					PERFORM check_google_user_type(NEW.owner_id, 'manager');

					RETURN NEW;
				END
			$$;
		")

		repo().query!("
			CREATE FUNCTION check_if_google_user_is_congregation() RETURNS TRIGGER LANGUAGE plpgsql
			AS $$
				DECLARE
					google_user_type VARCHAR;
				BEGIN
					PERFORM check_google_user_type(NEW.owner_id, 'congregation');

					RETURN NEW;
				END
			$$;
		")

		repo().query!("
			CREATE TRIGGER check_if_manager_has_correct_google_user
				AFTER INSERT
				ON managers
				FOR EACH ROW
				EXECUTE PROCEDURE check_if_google_user_is_manager();
		")

		repo().query!("
			CREATE TRIGGER check_if_congregation_has_correct_google_user
				AFTER INSERT
				ON congregations
				FOR EACH ROW
				EXECUTE PROCEDURE check_if_google_user_is_congregation();
		")
	end

	defp execute_down do
		repo().query!("DROP TRIGGER check_if_manager_has_correct_google_user ON managers;");
		repo().query!("DROP TRIGGER check_if_congregation_has_correct_google_user ON congregations;");
		repo().query!("DROP FUNCTION check_if_google_user_is_manager;");
		repo().query!("DROP FUNCTION check_if_google_user_is_congregation;");
		repo().query!("DROP FUNCTION check_google_user_type(UUID, VARCHAR);");
	end
end
