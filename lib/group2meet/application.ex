defmodule Group2meet.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      Group2meetWeb.Telemetry,
      # Start the Ecto repository
      Group2meet.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Group2meet.PubSub},
      # Start Finch
      {Finch, name: Group2meet.Finch},
      # Start the Endpoint (http/https)
      Group2meetWeb.Endpoint
      # Start a worker by calling: Group2meet.Worker.start_link(arg)
      # {Group2meet.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Group2meet.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Group2meetWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
