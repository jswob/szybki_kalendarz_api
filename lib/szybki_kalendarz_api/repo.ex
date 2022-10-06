defmodule SzybkiKalendarzApi.Repo do
  use Ecto.Repo,
    otp_app: :szybki_kalendarz_api,
    adapter: Ecto.Adapters.Postgres
end
