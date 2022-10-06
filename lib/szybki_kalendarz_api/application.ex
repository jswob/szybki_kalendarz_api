defmodule SzybkiKalendarzApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      SzybkiKalendarzApi.Repo,
      # Start the Telemetry supervisor
      SzybkiKalendarzApiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: SzybkiKalendarzApi.PubSub},
      # Start the Endpoint (http/https)
      SzybkiKalendarzApiWeb.Endpoint
      # Start a worker by calling: SzybkiKalendarzApi.Worker.start_link(arg)
      # {SzybkiKalendarzApi.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SzybkiKalendarzApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SzybkiKalendarzApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
