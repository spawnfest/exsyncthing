defmodule SyncThing.Core.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts)
  end

  @impl true
  def init(_opts) do
    :ssl.start()

    registry_opts = [
      name: SyncThing.Core.FolderRegistry,
      keys: :unique
    ]

    children = [
      {Registry, registry_opts},
      {SyncThing.Core.FolderSupervisor, []},
      {SyncThing.Core.ConnectionSupervisor, []},
      {SyncThing.Core.Acceptor, []}
      # {SyncThing.Core.LibrarySupervisor, []}
    ]

    Supervisor.init(children, strategy: :rest_for_one)
  end
end
