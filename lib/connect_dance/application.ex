defmodule ConnectDance.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ConnectDanceWeb.Telemetry,
      ConnectDance.Repo,
      {DNSCluster, query: Application.get_env(:connect_dance, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ConnectDance.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ConnectDance.Finch},
      # Start a worker by calling: ConnectDance.Worker.start_link(arg)
      # {ConnectDance.Worker, arg},
      # Start to serve requests, typically the last entry
      ConnectDanceWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ConnectDance.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ConnectDanceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
