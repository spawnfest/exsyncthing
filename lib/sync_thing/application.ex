defmodule SyncThing.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {SyncThing.LocalDiscovery.Announcer, []}
      # Starts a worker by calling: SyncThing.Worker.start_link(arg)
      # {SyncThing.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SyncThing.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
