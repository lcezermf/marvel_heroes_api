defmodule TenExTakeHome.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      TenExTakeHomeWeb.Telemetry,
      # Start the Ecto repository
      TenExTakeHome.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: TenExTakeHome.PubSub},
      # Start Finch
      {Finch, name: TenExTakeHome.Finch},
      # Start the Endpoint (http/https)
      TenExTakeHomeWeb.Endpoint,
      %{id: TenExTakeHome.Cache, start: {TenExTakeHome.Cache, :start_link, []}}
      # Start a worker by calling: TenExTakeHome.Worker.start_link(arg)
      # {TenExTakeHome.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TenExTakeHome.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TenExTakeHomeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
